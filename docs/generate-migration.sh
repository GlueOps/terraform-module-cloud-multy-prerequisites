#!/usr/bin/env bash
# Generates a tenant repo's complete migration to per-cluster module calls:
# rewrites tenant.tf, writes providers.tf, and writes moved-migration.tf.
#
# Usage, in the tenant repo, on a fresh branch, with this repo checked out at
# the ref the tenant should pin:
#   bash /path/to/this-repo/docs/generate-migration.sh vX.Y.Z
#
# Reads the existing (old-format) ./tenant.tf: tenant-scoped arguments move
# onto module "tenant_base", every cluster_environments element becomes its
# own module "cluster_<environment_name>" block, autoglue credentials are
# hoisted into locals for reuse by providers.tf, and opsgenie_emails (unused)
# is dropped. Fails loudly on any argument it does not recognize.
#
# Review the result, then gate on the PR plan: ONLY "has moved" lines and
# "Plan: 0 to add, 0 to change, 0 to destroy."
set -euo pipefail

[ $# -eq 1 ] || { echo "usage: $0 <ref-to-pin (e.g. v0.85.0)>" >&2; exit 1; }
REF=$1
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
[ -f tenant.tf ] || { echo "no tenant.tf in current directory" >&2; exit 1; }

REF="$REF" python3 - <<'PYEOF'
import os, re, sys

ref = os.environ['REF']
src = open('tenant.tf').read()

m = re.search(r'^module "tenant" \{\n', src, re.M)
if not m:
    sys.exit('tenant.tf has no module "tenant" block (already migrated?)')

# find the matching closing brace at column 0, skipping heredocs
start = m.start()
i = m.end()
depth = 1
heredoc = None
for line in src[i:].splitlines(keepends=True):
    stripped = line.strip()
    if heredoc:
        if stripped == heredoc:
            heredoc = None
    else:
        hd = re.search(r'<<-?([A-Z][A-Z0-9_]*)\s*$', line)
        if hd:
            heredoc = hd.group(1)
        else:
            depth += line.count('{') - line.count('}')
    i += len(line)
    if depth == 0:
        break
else:
    sys.exit('unbalanced module "tenant" block')
block = src[m.end():i - 2]  # body without the closing "}\n"
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
            sys.exit(f'unrecognized line in module "tenant": {line.strip()[:80]}')
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
    sys.exit(f'unrecognized module "tenant" arguments (handle manually): {unknown}')
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
open('tenant.tf', 'w').write(out)

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
print(f'environments: {", ".join(names)}', file=sys.stderr)
PYEOF

bash "$SCRIPT_DIR/generate-moved-blocks.sh" > moved-migration.tf
if command -v tofu > /dev/null 2>&1; then tofu fmt tenant.tf providers.tf moved-migration.tf > /dev/null; fi
echo "wrote tenant.tf, providers.tf, moved-migration.tf" >&2
