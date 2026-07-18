#!/usr/bin/env bash
# Generates the moved blocks needed to migrate a tenant repo from the legacy
# monolithic call (module "tenant" sourcing this repo's pre-split root) to
# direct per-cluster module calls (module "tenant_base" + one
# module "cluster_<environment_name>" block per cluster environment).
#
# Usage, in the tenant repo AFTER rewriting tenant.tf, with this repo checked
# out at the ref the new tenant_base/cluster_* blocks pin:
#   bash /path/to/this-repo/docs/generate-moved-blocks.sh > moved-migration.tf
#
# Environment names are derived from the module "cluster_<env>" labels in
# the root .tf files (pass them explicitly as arguments to override).
#
# No state access needed: the full address set is derived from the module
# sources — shared resource/module names from modules/tenant-base, and
# (per-environment names from modules/captain-cluster) x (environment names).
# Blocks for instances that do not exist in a tenant's state (e.g.
# generate_gluekube_creds for environments without provider_credentials) are
# ignored by tofu — emitting them unconditionally is safe.
#
# The output is chained (hop 1 relocates legacy root-level addresses into the
# tenant-base/captain-cluster shape, hop 2 splits them out to the new module
# blocks), and tofu follows the chain — so the plan is clean regardless of
# which module version the tenant last applied. Verified empirically from
# both state forms: moves only, 0/0/0.
#
# Assumptions:
#   - the old call is named module "tenant" (set OLD_MODULE_LABEL if the tenant
#     named it something else; generate-migration.sh detects and passes it
#     automatically) and is DELETED in the same PR (OpenTofu rejects moved
#     blocks whose "from" is still declared in config)
#   - the new per-cluster blocks are named module "cluster_<environment_name>"
#   - every cluster block passes cluster_environments = [<that one environment>]
#     so all for_each keys keep their environment name
#
# The migration PR's CI plan must show ONLY "has moved" lines and
# "Plan: 0 to add, 0 to change, 0 to destroy." Delete moved-migration.tf in a
# follow-up PR once the migration has applied.
set -euo pipefail

# label of the legacy module call in the tenant repo (state addresses derive
# from it). Overridable because tenants may have named the call anything.
OLD_LABEL="${OLD_MODULE_LABEL:-tenant}"

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"

# every resource/module name declared in a module dir, skipping heredoc bodies
# (generated-file templates contain blocks that are text, not declarations)
inventory() {
  awk '
    inheredoc { if ($0 ~ ("^[[:space:]]*" tag "$")) inheredoc = 0; next }
    /<</ {
      tmp = $0
      sub(/.*<<-?/, "", tmp)
      sub(/[^A-Z0-9_].*/, "", tmp)
      if (tmp != "") { tag = tmp; inheredoc = 1 }
    }
    { print }
  ' "$1"/*.tf \
    | grep -oE '^(resource "[a-z0-9_]+" "[a-z0-9_]+"|module "[a-z0-9_]+")' \
    | sed -E 's/^resource "([^"]+)" "([^"]+)"$/\1.\2/; s/^module "([^"]+)"$/module.\1/' \
    | sort -u
}

if [ $# -eq 0 ]; then
  # derive environment names from the root .tf files in the current directory
  ls ./*.tf > /dev/null 2>&1 || { echo "no .tf files in current directory; pass environment names explicitly" >&2; exit 1; }
  if grep -qE "^module \"$OLD_LABEL\"" ./*.tf; then
    echo "a root .tf file still declares module \"$OLD_LABEL\" — delete the old call first" >&2
    exit 1
  fi
  envs=$(grep -hoE '^module "cluster_[A-Za-z0-9_-]+"' ./*.tf | sed -E 's/^module "cluster_([A-Za-z0-9_-]+)"$/\1/' | sort -u)
  [ -n "$envs" ] || { echo 'no module "cluster_<env>" blocks found in root .tf files' >&2; exit 1; }
  # shellcheck disable=SC2086
  set -- $envs
fi

# hop 1: legacy root-level addresses -> tenant-base/captain-cluster shape.
# Pure prefix rewrites; no-ops for state already past this hop.
inventory "$REPO_ROOT/modules/tenant-base" | while IFS= read -r name; do
  printf 'moved {\n  from = module.%s.%s\n  to   = module.%s.module.tenant_base.%s\n}\n\n' "$OLD_LABEL" "$name" "$OLD_LABEL" "$name"
done
inventory "$REPO_ROOT/modules/captain-cluster" | while IFS= read -r name; do
  printf 'moved {\n  from = module.%s.%s\n  to   = module.%s.module.captain_cluster.%s\n}\n\n' "$OLD_LABEL" "$name" "$OLD_LABEL" "$name"
done

# hop 2: tenant-base/captain-cluster shape -> the new per-cluster blocks
printf 'moved {\n  from = module.%s.module.tenant_base\n  to   = module.tenant_base\n}\n' "$OLD_LABEL"

inventory "$REPO_ROOT/modules/captain-cluster" | while IFS= read -r name; do
  for env in "$@"; do
    printf '\nmoved {\n  from = module.%s.module.captain_cluster.%s["%s"]\n  to   = module.cluster_%s.%s["%s"]\n}\n' "$OLD_LABEL" "$name" "$env" "$env" "$name" "$env"
  done
done
