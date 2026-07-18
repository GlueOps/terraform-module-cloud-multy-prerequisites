#!/usr/bin/env bash
# Generates a tenant repo's complete migration to per-cluster module calls:
# rewrites the file holding the legacy call, writes providers.tf, and writes
# moved-migration.tf.
#
# Usage, in the tenant repo, on a fresh branch, with this repo checked out at
# the ref the tenant should pin:
#   bash /path/to/this-repo/docs/generate-migration.sh [vX.Y.Z]
# With no argument you are prompted for the ref to pin; an empty answer (or a
# non-interactive run without an argument) defaults to main.
#
# Finds the legacy module call by SOURCE in any root .tf file (file and
# module names do not matter): tenant-scoped arguments move
# onto module "tenant_base", every cluster_environments element becomes its
# own module "cluster_<environment_name>" block, autoglue credentials are
# hoisted into locals (or reused if already a local reference), and
# opsgenie_emails (unused) is dropped. Comments inside the legacy module call
# are NOT preserved. All validation happens BEFORE any file is written; the
# script fails loudly on anything it does not recognize.
#
# Review the result, then gate on the PR plan: ONLY "has moved" lines and
# "Plan: 0 to add, 0 to change, 0 to destroy."
set -euo pipefail

[ $# -le 1 ] || { echo "usage: $0 [ref-to-pin (e.g. v0.85.0)]" >&2; exit 1; }
REF="${1:-}"
if [ -z "$REF" ]; then
  if [ -t 0 ]; then
    read -r -p "Module ref to pin (e.g. v0.85.0) [main]: " REF || true
  fi
  REF="${REF:-main}"
fi
echo "pinning ref: $REF" >&2
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ls ./*.tf > /dev/null 2>&1 || { echo "no .tf files in current directory" >&2; exit 1; }

PYOUT=$(REF="$REF" python3 - <<'PYEOF'
import glob
import os
import re
import sys

ref = os.environ['REF']

MODULE_REPO = 'terraform-module-cloud-multy-prerequisites'
HEREDOC_RE = re.compile(r'<<-?([A-Za-z_][A-Za-z0-9_]*)\s*$')

if os.path.exists('providers.tf'):
    sys.exit('providers.tf already exists — merge the MIGRATION.md template into it manually, then use generate-moved-blocks.sh directly')

def strip_line_comment(line):
    # drop a trailing # or // comment, respecting double-quoted strings
    # (so https:// URLs and # inside values survive); preserves the line ending
    ending = ''
    body = line
    if body.endswith('\n'):
        body, ending = body[:-1], '\n'
    out = []
    in_str = False
    i = 0
    while i < len(body):
        ch = body[i]
        if in_str:
            if ch == '\\' and i + 1 < len(body):
                out.append(body[i:i + 2])
                i += 2
                continue
            if ch == '"':
                in_str = False
            out.append(ch)
            i += 1
            continue
        if ch == '"':
            in_str = True
            out.append(ch)
            i += 1
            continue
        if ch == '#' or body[i:i + 2] == '//':
            break
        out.append(ch)
        i += 1
    return ''.join(out).rstrip() + ending

def structural(s):
    # the line with quoted-string CONTENTS blanked out, so brace/bracket math
    # is never fooled by braces inside values
    out = []
    in_str = False
    i = 0
    while i < len(s):
        ch = s[i]
        if in_str:
            if ch == '\\' and i + 1 < len(s):
                i += 2
                continue
            if ch == '"':
                in_str = False
                out.append(ch)
            i += 1
            continue
        out.append(ch)
        if ch == '"':
            in_str = True
        i += 1
    return ''.join(out)

def strip_comments(text):
    # comment-free version of a config fragment; heredoc bodies untouched.
    # Comments are NOT preserved through conversion (by design).
    out = []
    heredoc = None
    for line in text.splitlines(keepends=True):
        if heredoc:
            out.append(line)
            if line.strip() == heredoc:
                heredoc = None
            continue
        s = strip_line_comment(line)
        if s.strip() == '' and line.strip() != '':
            continue  # the line was only a comment — drop it entirely
        hd = HEREDOC_RE.search(s)
        if hd:
            heredoc = hd.group(1)
        out.append(s)
    return ''.join(out)

def block_end(text, start_of_body):
    # index just past the matching close brace, heredoc- and string-aware
    i = start_of_body
    depth = 1
    heredoc = None
    for line in text[i:].splitlines(keepends=True):
        stripped = line.strip()
        if heredoc:
            if stripped == heredoc:
                heredoc = None
        else:
            s = strip_line_comment(line)
            hd = HEREDOC_RE.search(s)
            if hd:
                heredoc = hd.group(1)
            else:
                st = structural(s)
                depth += st.count('{') - st.count('}')
        i += len(line)
        if depth == 0:
            return i
    sys.exit('unbalanced module block')

# ---------------------------------------------------------------- discovery
# the legacy call is identified by its SOURCE (this repo's root, not
# //modules/), never by its label or file name
legacy = []
for f in sorted(glob.glob('*.tf')):
    # binary check: text-mode reads silently translate CRLF and would hide it
    if b'\r' in open(f, 'rb').read():
        sys.exit(f'{f} has CRLF line endings — convert to LF (e.g. dos2unix) and rerun')
    text = open(f).read()
    for m in re.finditer(r'^module\s+"([A-Za-z0-9_-]+)"\s*\{[ \t]*\n', text, re.M):
        end = block_end(text, m.end())
        body = text[m.end():end]
        sm = re.search(r'^\s*source\s*=\s*"([^"]+)"', body, re.M)
        if sm and MODULE_REPO in sm.group(1) and '//modules/' not in sm.group(1):
            legacy.append((f, m.group(1), m.start(), m.end(), end))
if not legacy:
    sys.exit(f'no module call sourcing the {MODULE_REPO} root found in any root .tf file '
             '(already migrated? if the call exists but is unformatted, run tofu fmt first)')
if len(legacy) > 1:
    sys.exit(f'multiple module calls source the {MODULE_REPO} root ({[(l[0], l[1]) for l in legacy]}) — handle manually')
legacy_file, old_label, start, body_start, end = legacy[0]
src = open(legacy_file).read()
print(f'legacy call: module "{old_label}" in {legacy_file}', file=sys.stderr)

# split off the closing-brace line robustly (tolerates trailing whitespace and
# a missing final newline); comments inside the block are dropped from here on
seg_lines = src[body_start:end].splitlines(keepends=True)
if strip_line_comment(seg_lines[-1]).strip() != '}':
    sys.exit(f'unexpected closing line of module "{old_label}": {seg_lines[-1].strip()[:60]}')
block = strip_comments(''.join(seg_lines[:-1]))
preamble, postamble = src[:start], src[end:]

# ------------------------------------------------------------------ parsing
# top-level attributes of the module body (value may span lines)
attrs = {}
lines = block.splitlines(keepends=True)
j = 0
while j < len(lines):
    line = lines[j]
    am = re.match(r'^  ([a-z0-9_]+)\s*=\s*(.*)$', line, re.S)
    if not am:
        if line.strip():
            sys.exit(f'unrecognized line in module "{old_label}": {line.strip()[:80]}')
        j += 1
        continue
    key, val = am.group(1), am.group(2)
    st = structural(val)
    depth = st.count('{') + st.count('[') - st.count('}') - st.count(']')
    heredoc = None
    hd = HEREDOC_RE.search(val)
    if hd:
        heredoc = hd.group(1)
    j += 1
    while (depth > 0 or heredoc) and j < len(lines):
        nxt = lines[j]
        if heredoc:
            if nxt.strip() == heredoc:
                heredoc = None
        else:
            hd = HEREDOC_RE.search(nxt)
            if hd:
                heredoc = hd.group(1)
            else:
                st = structural(nxt)
                depth += st.count('{') + st.count('[') - st.count('}') - st.count(']')
        val += nxt
        j += 1
    attrs[key] = val.rstrip('\n')

CARRY = ['tenant_key', 'tenant_account_id', 'management_tenant_dns_zoneid',
         'this_is_development', 'primary_region', 'backup_region', 'github_owner']
SPECIAL = ['source', 'autoglue_credentials', 'cluster_environments',
           'management_tenant_dns_aws_account_id', 'opsgenie_emails']
unknown = [k for k in attrs if k not in CARRY + SPECIAL]
if unknown:
    sys.exit(f'unrecognized module "{old_label}" arguments (handle manually): {unknown}')
missing = [k for k in CARRY + ['autoglue_credentials', 'cluster_environments',
                               'management_tenant_dns_aws_account_id'] if k not in attrs]
if missing:
    sys.exit(f'missing expected arguments: {missing}')

# ------------------------------------------------- cluster_environments split
ce_val = attrs['cluster_environments']
if '[' not in structural(ce_val):
    sys.exit('cluster_environments must be an inline list literal for this converter '
             f'(found: {ce_val.strip()[:60]}) — inline the environments or migrate manually')
list_body = ce_val[ce_val.index('[') + 1:ce_val.rindex(']')]

def env_abort(msg, line):
    sys.exit(f'cluster_environments: {msg}: {line.strip()[:80]}\n'
             'put each environment object on its own lines (or migrate manually)')

envs = []
depth = 0
heredoc = None
cur = ''
for line in list_body.splitlines(keepends=True):
    stripped = line.strip()
    if heredoc:
        cur += line
        if stripped == heredoc:
            heredoc = None
        continue
    if depth == 0:
        if not stripped:
            continue
        if stripped.startswith('{'):
            st = structural(line)
            if st.count('{') == st.count('}') and stripped.rstrip(',').rstrip().endswith('}'):
                # complete single-line object
                inner = stripped.rstrip(',').rstrip()
                envs.append('      ' + inner[1:-1].strip())
                continue
            if stripped != '{':
                env_abort('unsupported object layout (content on the opening-brace line)', line)
            depth = 1
            cur = ''
            continue
        env_abort('unexpected content between environment objects', line)
    else:
        hd = HEREDOC_RE.search(strip_line_comment(line))
        if hd:
            heredoc = hd.group(1)
            cur += line
            continue
        st = structural(strip_line_comment(line))
        depth += st.count('{') - st.count('}')
        if depth == 0:
            rest = strip_line_comment(line).strip()
            if rest not in ('}', '},'):
                env_abort('unsupported object layout (content beside the closing brace)', line)
            envs.append(cur.rstrip('\n'))
            cur = ''
            continue
        cur += line
if depth != 0 or heredoc:
    sys.exit('cluster_environments: unbalanced environment object')
if not envs:
    sys.exit('no cluster_environments objects found')

# invariant: every environment object was captured individually
expected = len(re.findall(r'\benvironment_name\s*=', strip_comments(list_body)))
if expected != len(envs):
    sys.exit(f'cluster_environments: found {expected} environment_name entries but split '
             f'{len(envs)} objects — object layout not understood, migrate manually')

names = []
for e in envs:
    nm = re.search(r'environment_name\s*=\s*"([^"]+)"', e)
    if not nm:
        sys.exit('cluster_environments object without environment_name')
    names.append(nm.group(1))
for n in names:
    if not re.fullmatch(r'[A-Za-z0-9_-]+', n):
        sys.exit(f'environment_name "{n}" contains characters unsupported for a cluster_<env> module label')
if len(set(names)) != len(names):
    sys.exit(f'duplicate environment_name values: {sorted(n for n in set(names) if names.count(n) > 1)}')

# ------------------------------------------------------- pre-write validation
# generated labels must not collide with anything that stays in the repo
gen_labels = ['tenant_base'] + [f'cluster_{n}' for n in names]
rest_cfg = preamble + postamble
for lbl in gen_labels:
    if old_label == lbl or re.search(rf'^module\s+"{re.escape(lbl)}"', rest_cfg, re.M):
        sys.exit(f'a module named "{lbl}" already exists (or is the legacy call label) — resolve the collision first')

def locals_attrs(text, body_start_):
    # top-level attributes of a locals block: (name, abs_start, abs_end)
    out = []
    i = body_start_
    depth = 0
    heredoc = None
    cur_name = None
    cur_start = None
    for line in text[body_start_:].splitlines(keepends=True):
        stripped = line.strip()
        if heredoc:
            if stripped == heredoc:
                heredoc = None
        else:
            # structural decisions on the comment-free line; offsets (i) always
            # advance by the ORIGINAL line length
            s = strip_line_comment(line)
            ss = s.strip()
            if cur_name is None and ss == '}' and depth == 0:
                return out, i  # end of locals block
            am2 = re.match(r'^  ([A-Za-z0-9_-]+)\s*=', s) if depth == 0 else None
            if am2 and cur_name is None:
                cur_name, cur_start = am2.group(1), i
            hd2 = HEREDOC_RE.search(s)
            if hd2:
                heredoc = hd2.group(1)
            else:
                st2 = structural(s)
                depth += st2.count('{') + st2.count('[') - st2.count('}') - st2.count(']')
        i += len(line)
        if cur_name is not None and depth == 0 and heredoc is None:
            out.append((cur_name, cur_start, i))
            cur_name = None
    return out, i

def all_local_names():
    found = set()
    for f2 in sorted(glob.glob('*.tf')):
        t2 = open(f2).read()
        for m2 in re.finditer(r'^locals\s*\{[ \t]*\n', t2, re.M):
            spans, _ = locals_attrs(t2, m2.end())
            found.update(n for n, _s, _e in spans)
    return found

# autoglue credentials: reuse an existing local reference instead of hoisting a
# duplicate; only hoist an inline object, and never into a colliding name
ag_val = attrs['autoglue_credentials'].strip()
ag_is_ref = re.fullmatch(r'local\.[A-Za-z0-9_-]+', ag_val) is not None
if ag_is_ref:
    ag_ref = ag_val
    hoist = False
else:
    ag_ref = 'local.autoglue_credentials'
    hoist = True
    if 'autoglue_credentials' in all_local_names():
        sys.exit('a local named autoglue_credentials already exists but the legacy call passes an inline '
                 'object — unify them first (pass local.autoglue_credentials in the legacy call), then rerun')

def unquote_or_expr(v):
    return v.strip()

acct = unquote_or_expr(attrs['tenant_account_id'])
mgmt = unquote_or_expr(attrs['management_tenant_dns_aws_account_id'])
primary = unquote_or_expr(attrs['primary_region'])
backup = unquote_or_expr(attrs['backup_region'])
owner = unquote_or_expr(attrs['github_owner'])
for nm_, v_ in [('tenant_account_id', acct), ('management_tenant_dns_aws_account_id', mgmt),
                ('primary_region', primary), ('backup_region', backup), ('github_owner', owner)]:
    if '\n' in v_:
        sys.exit(f'{nm_} is not a single-line value — migrate manually')

def interp(v):
    # role_arn interpolation: literal strings embed directly, expressions get ${...}
    if v.startswith('"') and v.endswith('"'):
        return v[1:-1]
    return '${' + v + '}'

def region(v):
    return v  # quoted literal or expression — both valid as an attribute value

# ------------------------------------------------------------ build outputs
SRC = 'git::https://github.com/GlueOps/terraform-module-cloud-multy-prerequisites.git'

out = preamble
if hoist:
    out += 'locals {\n  autoglue_credentials = ' + re.sub(r'^  ', '', attrs['autoglue_credentials'], flags=re.M).replace('\n', '\n  ') + '\n}\n\n'
out += f'module "tenant_base" {{\n  source = "{SRC}//modules/tenant-base?ref={ref}"\n'
out += '  providers = {\n    aws.clientaccount         = aws.clientaccount\n    aws.management-tenant-dns = aws.management-tenant-dns\n    aws.primaryregion         = aws.primaryregion\n    aws.replicaregion         = aws.replicaregion\n    aws.dnssec-us-east-1      = aws.dnssec-us-east-1\n  }\n'
for k in CARRY:
    out += f'  {k} = {attrs[k]}\n'
out += f'  autoglue_credentials = {ag_ref}\n'
out += '  environment_names    = [' + ', '.join(f'"{n}"' for n in names) + ']\n'
out += '}\n'
for n, e in zip(names, envs):
    out += f'\nmodule "cluster_{n}" {{\n  source = "{SRC}//modules/captain-cluster?ref={ref}"\n'
    out += '  providers = {\n    aws.clientaccount = aws.clientaccount\n    aws.primaryregion = aws.primaryregion\n    aws.replicaregion = aws.replicaregion\n  }\n'
    out += '  tenant         = module.tenant_base.captain_cluster_inputs\n'
    out += '  tenant_secrets = module.tenant_base.captain_cluster_secrets\n'
    out += '  cluster_environments = [\n    {\n' + e + '\n    }\n  ]\n}\n'
out += postamble

providers = f'''terraform {{
  required_providers {{
    aws = {{
      source = "hashicorp/aws"
    }}
    random = {{
      source = "hashicorp/random"
    }}
    autoglue = {{
      source  = "registry.terraform.io/GlueOps/autoglue"
      version = "0.10.12"
    }}
    github = {{
      source = "integrations/github"
    }}
  }}
}}

# Token comes from the GITHUB_TOKEN environment variable in CI. Set token here
# instead if you prefer it fully inline.
provider "github" {{
  owner = {owner}
}}

provider "aws" {{
  alias  = "clientaccount"
  region = {region(primary)}
  assume_role {{
    role_arn = "arn:aws:iam::{interp(acct)}:role/OrganizationAccountAccessRole"
  }}
}}

provider "aws" {{
  alias  = "management-tenant-dns"
  region = {region(primary)}
  assume_role {{
    role_arn = "arn:aws:iam::{interp(mgmt)}:role/OrganizationAccountAccessRole"
  }}
}}

provider "aws" {{
  alias  = "primaryregion"
  region = {region(primary)}
  assume_role {{
    role_arn = "arn:aws:iam::{interp(acct)}:role/OrganizationAccountAccessRole"
  }}
}}

provider "aws" {{
  alias  = "replicaregion"
  region = {region(backup)}
  assume_role {{
    role_arn = "arn:aws:iam::{interp(acct)}:role/OrganizationAccountAccessRole"
  }}
}}

provider "aws" {{
  alias  = "dnssec-us-east-1"
  region = "us-east-1" # Route53 DNSSEC requires its KMS key in us-east-1
  assume_role {{
    role_arn = "arn:aws:iam::{interp(acct)}:role/OrganizationAccountAccessRole"
  }}
}}

provider "autoglue" {{
  base_url   = {ag_ref}.base_url
  org_key    = {ag_ref}.autoglue_key
  org_secret = {ag_ref}.autoglue_org_secret
}}
'''

# --------------------------------------------------------------- write phase
# (all validation is done — nothing below here should fail on tenant input)
open(legacy_file, 'w').write(out)
open('providers.tf', 'w').write(providers)
if 'opsgenie_emails' in attrs:
    print('note: dropped opsgenie_emails (unused)', file=sys.stderr)

# prune locals the migration left unreferenced (e.g. an opsgenie_emails local
# whose only consumer was the dropped argument). Fixpoint: removing one local
# can orphan another it referenced.
pruned_any = True
pruned_names = []
while pruned_any:
    pruned_any = False
    files = sorted(glob.glob('*.tf'))
    corpus = {f2: open(f2).read() for f2 in files}
    everything = '\n'.join(corpus.values())
    for f2 in files:
        text = corpus[f2]
        edits = []
        for m2 in re.finditer(r'^locals\s*\{[ \t]*\n', text, re.M):
            attrs_spans, _ = locals_attrs(text, m2.end())
            for name, s_, e_ in attrs_spans:
                if not re.search(r'\blocal\.' + re.escape(name) + r'\b', everything):
                    edits.append((s_, e_, name))
        if edits:
            for s_, e_, name in sorted(edits, reverse=True):
                text = text[:s_] + text[e_:]
                pruned_names.append(name)
            # drop locals blocks that became empty
            text = re.sub(r'^locals\s*\{[ \t]*\n\s*\}\n', '', text, flags=re.M)
            open(f2, 'w').write(text)
            pruned_any = True

for f2 in sorted(glob.glob('*.tf')):
    if open(f2).read().strip() == '':
        os.remove(f2)
        print(f'note: removed empty {f2}', file=sys.stderr)
if pruned_names:
    print(f'note: pruned unreferenced locals: {", ".join(sorted(set(pruned_names)))}', file=sys.stderr)

print(f'environments: {", ".join(names)}', file=sys.stderr)
print(old_label + '\t' + legacy_file + '\t' + ' '.join(names))
PYEOF
)
[ -n "$PYOUT" ] || { echo "conversion failed" >&2; exit 1; }
OLD_LABEL=$(printf '%s\n' "$PYOUT" | cut -f1)
LEGACY_FILE=$(printf '%s\n' "$PYOUT" | cut -f2)
ENVS=$(printf '%s\n' "$PYOUT" | cut -f3-)
# environment names are passed explicitly so the moved-block generator never
# has to guess them from module labels
# shellcheck disable=SC2086
OLD_MODULE_LABEL="$OLD_LABEL" bash "$SCRIPT_DIR/generate-moved-blocks.sh" $ENVS > moved-migration.tf
if command -v tofu > /dev/null 2>&1; then tofu fmt "$LEGACY_FILE" providers.tf moved-migration.tf > /dev/null; fi
echo "wrote $LEGACY_FILE, providers.tf, moved-migration.tf" >&2
