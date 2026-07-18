#!/usr/bin/env bash
# Generates a tenant repo's complete migration to per-cluster module calls:
# rewrites tenant.tf, writes providers.tf, and writes moved-migration.tf.
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
# hoisted into locals for reuse by providers.tf, and opsgenie_emails (unused)
# is dropped. Comments inside the legacy module call are NOT preserved.
# Fails loudly on any argument it does not recognize.
#
# Review the result, then gate on the PR plan: ONLY "has moved" lines and
# "Plan: 0 to add, 0 to change, 0 to destroy."
set -euo pipefail

[ $# -le 1 ] || { echo "usage: $0 [ref-to-pin (e.g. v0.85.0)]" >&2; exit 1; }
REF="${1:-}"
if [ -z "$REF" ]; then
  if [ -t 0 ]; then
    read -r -p "Module ref to pin (e.g. v0.85.0) [main]: " REF
  fi
  REF="${REF:-main}"
fi
echo "pinning ref: $REF" >&2
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ls ./*.tf > /dev/null 2>&1 || { echo "no .tf files in current directory" >&2; exit 1; }

OLD_LABEL=$(REF="$REF" python3 - <<'PYEOF'
import os, re, sys

import glob

ref = os.environ['REF']

MODULE_REPO = 'terraform-module-cloud-multy-prerequisites'

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
        hd = re.search(r'<<-?([A-Z][A-Z0-9_]*)\s*$', s)
        if hd:
            heredoc = hd.group(1)
        out.append(s)
    return ''.join(out)

if os.path.exists('providers.tf'):
    sys.exit('providers.tf already exists — merge the MIGRATION.md template into it manually, then use generate-moved-blocks.sh directly')

def block_end(text, start_of_body):
    # index just past the matching close brace, heredoc-aware
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
            hd = re.search(r'<<-?([A-Z][A-Z0-9_]*)\s*$', s)
            if hd:
                heredoc = hd.group(1)
            else:
                depth += s.count('{') - s.count('}')
        i += len(line)
        if depth == 0:
            return i
    sys.exit('unbalanced module block')

# the legacy call is identified by its SOURCE (this repo's root, not //modules/),
# never by its label or file name — tenants may have named both anything
legacy = []
for f in sorted(glob.glob('*.tf')):
    text = open(f).read()
    for m in re.finditer(r'^module "([A-Za-z0-9_-]+)" \{\n', text, re.M):
        end = block_end(text, m.end())
        body = text[m.end():end - 2]
        sm = re.search(r'^\s*source\s*=\s*"([^"]+)"', body, re.M)
        if sm and MODULE_REPO in sm.group(1) and '//modules/' not in sm.group(1):
            legacy.append((f, m.group(1), m.start(), m.end(), end))
if not legacy:
    sys.exit(f'no module call sourcing the {MODULE_REPO} root found in any root .tf file (already migrated?)')
if len(legacy) > 1:
    sys.exit(f'multiple module calls source the {MODULE_REPO} root ({[(l[0], l[1]) for l in legacy]}) — handle manually')
legacy_file, old_label, start, body_start, i = legacy[0]
src = open(legacy_file).read()
print(f'legacy call: module "{old_label}" in {legacy_file}', file=sys.stderr)

# body without the closing "}\n", comments dropped: everything parsed (and
# re-emitted) from here on is comment-free
block = strip_comments(src[body_start:i - 2])
preamble, postamble = src[:start], src[i:]

# parse top-level attributes of the module body (value may span lines)
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
    depth = val.count('{') + val.count('[') - val.count('}') - val.count(']')
    heredoc = None
    hd = re.search(r'<<-?([A-Z][A-Z0-9_]*)\s*$', val)
    if hd:
        heredoc = hd.group(1)
    j += 1
    while (depth > 0 or heredoc) and j < len(lines):
        nxt = lines[j]
        if heredoc:
            if nxt.strip() == heredoc:
                heredoc = None
        else:
            hd = re.search(r'<<-?([A-Z][A-Z0-9_]*)\s*$', nxt)
            if hd:
                heredoc = hd.group(1)
            else:
                depth += nxt.count('{') + nxt.count('[') - nxt.count('}') - nxt.count(']')
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
missing = [k for k in CARRY + ['autoglue_credentials', 'cluster_environments'] if k not in attrs]
if missing:
    sys.exit(f'missing expected arguments: {missing}')

# split cluster_environments into its top-level objects
list_body = attrs['cluster_environments']
list_body = list_body[list_body.index('[') + 1:list_body.rindex(']')]
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
    hd = re.search(r'<<-?([A-Z][A-Z0-9_]*)\s*$', line)
    if depth == 0:
        if stripped.startswith('{'):
            depth = 1
            cur = ''
            continue
    else:
        if hd:
            heredoc = hd.group(1)
        else:
            depth += line.count('{') - line.count('}')
        if depth == 0:
            envs.append(cur.rstrip('\n').rstrip(',').rstrip())
            cur = ''
            continue
        cur += line
if not envs:
    sys.exit('no cluster_environments objects found')

names = []
for e in envs:
    nm = re.search(r'environment_name\s*=\s*"([^"]+)"', e)
    if not nm:
        sys.exit('cluster_environments object without environment_name')
    names.append(nm.group(1))

SRC = 'git::https://github.com/GlueOps/terraform-module-cloud-multy-prerequisites.git'

def dedent_env(e):
    # env objects were at 4-space list indent; keep verbatim
    return e

out = preamble
out += 'locals {\n  autoglue_credentials = ' + re.sub(r'^  ', '', attrs['autoglue_credentials'], flags=re.M).replace('\n', '\n  ') + '\n}\n\n'
out += f'module "tenant_base" {{\n  source = "{SRC}//modules/tenant-base?ref={ref}"\n'
out += '  providers = {\n    aws.clientaccount         = aws.clientaccount\n    aws.management-tenant-dns = aws.management-tenant-dns\n    aws.primaryregion         = aws.primaryregion\n    aws.replicaregion         = aws.replicaregion\n    aws.dnssec-us-east-1      = aws.dnssec-us-east-1\n  }\n'
for k in ['tenant_key', 'tenant_account_id', 'management_tenant_dns_zoneid',
          'this_is_development', 'primary_region', 'backup_region', 'github_owner']:
    out += f'  {k} = {attrs[k]}\n'
out += '  autoglue_credentials = local.autoglue_credentials\n'
out += '  environment_names    = [' + ', '.join(f'"{n}"' for n in names) + ']\n'
out += '}\n'
for n, e in zip(names, envs):
    out += f'\nmodule "cluster_{n}" {{\n  source = "{SRC}//modules/captain-cluster?ref={ref}"\n'
    out += '  providers = {\n    aws.clientaccount = aws.clientaccount\n    aws.primaryregion = aws.primaryregion\n    aws.replicaregion = aws.replicaregion\n  }\n'
    out += '  tenant         = module.tenant_base.captain_cluster_inputs\n'
    out += '  tenant_secrets = module.tenant_base.captain_cluster_secrets\n'
    out += '  cluster_environments = [\n    {\n' + e + '\n    }\n  ]\n}\n'
out += postamble
open(legacy_file, 'w').write(out)

def unquote_or_expr(v):
    v = v.split('#')[0].strip()
    return v

acct = unquote_or_expr(attrs['tenant_account_id'])
mgmt = unquote_or_expr(attrs['management_tenant_dns_aws_account_id']) if 'management_tenant_dns_aws_account_id' in attrs else None
if mgmt is None:
    sys.exit('management_tenant_dns_aws_account_id not found (needed for providers.tf)')
primary = unquote_or_expr(attrs['primary_region'])
backup = unquote_or_expr(attrs['backup_region'])
owner = unquote_or_expr(attrs['github_owner'])

def interp(v):
    # produce the interpolation for a role_arn: literal strings embed directly,
    # expressions get ${...}
    if v.startswith('"') and v.endswith('"'):
        return v[1:-1]
    return '${' + v + '}'

def region(v):
    if v.startswith('"') and v.endswith('"'):
        return v
    return v  # expression: emit as-is (rare)

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
  base_url   = local.autoglue_credentials.base_url
  org_key    = local.autoglue_credentials.autoglue_key
  org_secret = local.autoglue_credentials.autoglue_org_secret
}}
'''
open('providers.tf', 'w').write(providers)
if 'opsgenie_emails' in attrs:
    print('note: dropped opsgenie_emails (unused)', file=sys.stderr)

# prune locals the migration left unreferenced (e.g. an opsgenie_emails local
# whose only consumer was the dropped argument). Fixpoint: removing one local
# can orphan another it referenced.
import glob

def locals_attrs(text, body_start):
    # top-level attributes of a locals block: (name, abs_start, abs_end)
    out = []
    i = body_start
    depth = 0
    heredoc = None
    cur_name = None
    cur_start = None
    for line in text[body_start:].splitlines(keepends=True):
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
            am = re.match(r'^  ([a-z0-9_]+)\s*=', s) if depth == 0 else None
            if am and cur_name is None:
                cur_name, cur_start = am.group(1), i
            hd = re.search(r'<<-?([A-Z][A-Z0-9_]*)\s*$', s)
            if hd:
                heredoc = hd.group(1)
            else:
                depth += s.count('{') + s.count('[') - s.count('}') - s.count(']')
        i += len(line)
        if cur_name is not None and depth == 0 and heredoc is None:
            out.append((cur_name, cur_start, i))
            cur_name = None
    return out, i

pruned_any = True
pruned_names = []
while pruned_any:
    pruned_any = False
    files = sorted(glob.glob('*.tf'))
    corpus = {f: open(f).read() for f in files}
    everything = '\n'.join(corpus.values())
    for f in files:
        text = corpus[f]
        edits = []
        for m in re.finditer(r'^locals \{\n', text, re.M):
            attrs_spans, _ = locals_attrs(text, m.end())
            for name, s, e in attrs_spans:
                if not re.search(r'\blocal\.' + re.escape(name) + r'\b', everything):
                    edits.append((s, e, name))
        if edits:
            for s, e, name in sorted(edits, reverse=True):
                text = text[:s] + text[e:]
                pruned_names.append(name)
            # drop locals blocks that became empty
            text = re.sub(r'^locals \{\n\s*\}\n', '', text, flags=re.M)
            open(f, 'w').write(text)
            pruned_any = True
    if pruned_any:
        continue

for f in sorted(glob.glob('*.tf')):
    if open(f).read().strip() == '':
        os.remove(f)
        print(f'note: removed empty {f}', file=sys.stderr)
if pruned_names:
    print(f'note: pruned unreferenced locals: {", ".join(sorted(set(pruned_names)))}', file=sys.stderr)

print(f'environments: {", ".join(names)}', file=sys.stderr)
print(f'{old_label}\t{legacy_file}')
PYEOF

)
[ -n "$OLD_LABEL" ] || { echo "conversion failed" >&2; exit 1; }
LEGACY_FILE=${OLD_LABEL#*	}
OLD_LABEL=${OLD_LABEL%%	*}
OLD_MODULE_LABEL="$OLD_LABEL" bash "$SCRIPT_DIR/generate-moved-blocks.sh" > moved-migration.tf
if command -v tofu > /dev/null 2>&1; then tofu fmt "$LEGACY_FILE" providers.tf moved-migration.tf > /dev/null; fi
echo "wrote tenant.tf, providers.tf, moved-migration.tf" >&2
