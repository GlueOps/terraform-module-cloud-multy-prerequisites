#!/usr/bin/env bash
# Generates the moved blocks needed to migrate a tenant repo from the
# backwards-compatible wrapper (module "tenant" calling this repo's root) to
# direct per-cluster module calls (module "tenant_base" + one
# module "cluster_<environment_name>" block per cluster environment).
#
# Usage, from a checkout of this repo at the ref the tenant is migrating TO
# (the same ref the new tenant_base/cluster_* blocks pin):
#   bash docs/generate-moved-blocks.sh nonprod prod > moved-migration.tf
#
# No state access needed: every resource and module call in
# modules/captain-cluster is for_each'd by environment name, so the full
# address set is (names found in the module source) x (environment names).
# Blocks for instances that do not exist in a tenant's state (e.g.
# generate_gluekube_creds for environments without provider_credentials) are
# ignored by tofu — emitting them unconditionally is safe.
#
# Assumptions:
#   - the old wrapper call is named module "tenant" and is DELETED in the same PR
#     (OpenTofu rejects moved blocks whose "from" is still declared in config)
#   - the new per-cluster blocks are named module "cluster_<environment_name>"
#   - every cluster block passes cluster_environments = [<that one environment>]
#     so all for_each keys keep their environment name
#
# With --chained as the first argument, the output additionally includes the
# wrapper-adoption hop (this repo's moved.tf re-anchored under module.tenant.),
# and tofu follows the chain: the SAME migration PR then plans clean whether or
# not the tenant ever applied the wrapper refactor. Use this to migrate in one
# PR without sequencing against the wrapper rollout. Verified from both
# starting states (raw pre-wrapper and wrapper-form): moves only, 0/0/0.
#
# The migration PR's CI plan must show ONLY "has moved" lines and
# "Plan: 0 to add, 0 to change, 0 to destroy." Delete moved-migration.tf in a
# follow-up PR once the migration has applied.
set -euo pipefail

MODULE_DIR="$(cd "$(dirname "$0")/../modules/captain-cluster" && pwd)"
REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"

chained=false
if [ "${1:-}" = "--chained" ]; then
  chained=true
  shift
fi

if [ $# -eq 0 ]; then
  # auto mode: run from the tenant repo directory after rewriting tenant.tf —
  # environment names are derived from the module "cluster_<env>" labels, and
  # chained output is used so the result works from any starting state.
  [ -f tenant.tf ] || { echo "auto mode: no tenant.tf in current directory; pass environment names explicitly" >&2; exit 1; }
  if grep -qE '^module "tenant"' tenant.tf; then
    echo 'auto mode: tenant.tf still declares module "tenant" — delete the wrapper call first' >&2
    exit 1
  fi
  envs=$(grep -oE '^module "cluster_[A-Za-z0-9_-]+"' tenant.tf | sed -E 's/^module "cluster_([A-Za-z0-9_-]+)"$/\1/' | sort -u)
  [ -n "$envs" ] || { echo 'auto mode: no module "cluster_<env>" blocks found in tenant.tf' >&2; exit 1; }
  chained=true
  # shellcheck disable=SC2086
  set -- $envs
fi

if $chained; then
  # hop 1: raw pre-wrapper -> wrapper-form. No-ops when state is already
  # wrapper-form. Mirrors moved.tf exactly, re-anchored under module.tenant.
  grep -E '^\s*(from|to)\s*=' "$REPO_ROOT/moved.tf" \
    | sed 's/^ *//' \
    | paste - - \
    | while IFS=$'\t' read -r fromline toline; do
        fromaddr=${fromline#from = }
        toaddr=${toline#to   = }
        printf 'moved {\n  from = module.tenant.%s\n  to   = module.tenant.%s\n}\n\n' "$fromaddr" "$toaddr"
      done
fi

printf 'moved {\n  from = module.tenant.module.tenant_base\n  to   = module.tenant_base\n}\n'

# strip heredoc bodies first: generated-file templates contain module blocks at
# column 0 that are text, not module calls in this module
awk '
  inheredoc { if ($0 ~ ("^[[:space:]]*" tag "$")) inheredoc = 0; next }
  /<</ {
    tmp = $0
    sub(/.*<<-?/, "", tmp)
    sub(/[^A-Z0-9_].*/, "", tmp)
    if (tmp != "") { tag = tmp; inheredoc = 1 }
  }
  { print }
' "$MODULE_DIR"/*.tf \
  | grep -oE '^(resource "[a-z0-9_]+" "[a-z0-9_]+"|module "[a-z0-9_]+")' \
  | sed -E 's/^resource "([^"]+)" "([^"]+)"$/\1.\2/; s/^module "([^"]+)"$/module.\1/' \
  | sort -u \
  | while IFS= read -r name; do
      for env in "$@"; do
        printf '\nmoved {\n  from = module.tenant.module.captain_cluster.%s["%s"]\n  to   = module.cluster_%s.%s["%s"]\n}\n' "$name" "$env" "$env" "$name" "$env"
      done
    done
