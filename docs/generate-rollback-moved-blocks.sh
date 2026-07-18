#!/usr/bin/env bash
# Generates the moved blocks needed to ROLL BACK a structural migration step of
# the tenant-base / captain-cluster split.
#
# NOTE: to roll back a bad RELEASE on one cluster you do NOT need this script —
# revert that cluster block's ?ref= pin. State addresses do not change. This
# script is only for abandoning a structural step entirely.
#
# Mode "split" — reverse a tenant's per-cluster migration:
#   module "tenant_base" + module "cluster_<env>" blocks -> single wrapper call.
#   Usage, from a checkout of this repo at the ref the tenant last applied:
#     bash docs/generate-rollback-moved-blocks.sh split nonprod prod > moved-rollback.tf
#   In the same PR: delete ALL tenant_base/cluster_* module blocks and restore
#   the wrapper call named module "tenant" (root of this repo, post-split ref).
#
# Mode "wrapper" — reverse the wrapper adoption itself, back to a PRE-SPLIT
#   release (e.g. v0.84.x), by inverting this repo's moved.tf:
#   Usage:
#     bash docs/generate-rollback-moved-blocks.sh wrapper > moved-rollback.tf
#   Put the blocks in the tenant repo root alongside module "tenant" pinned to
#   the pre-split ref.
#
# If clusters were on different refs, converging back to one wrapper version
# will also show generated-file content diffs in the plan for the clusters
# changing version (expected). Converge all cluster refs first if you want a
# moves-only 0/0/0 rollback plan.
#
# Either way the rollback PR's CI plan is the gate: only "has moved" lines and
# "Plan: 0 to add, 0 to change, 0 to destroy." Delete moved-rollback.tf in a
# follow-up PR once the rollback has applied.
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"

inventory() {
  # every resource/module name in captain-cluster, skipping heredoc bodies
  # (generated-file templates contain module blocks that are text, not calls)
  awk '
    inheredoc { if ($0 ~ ("^[[:space:]]*" tag "$")) inheredoc = 0; next }
    /<</ {
      tmp = $0
      sub(/.*<<-?/, "", tmp)
      sub(/[^A-Z0-9_].*/, "", tmp)
      if (tmp != "") { tag = tmp; inheredoc = 1 }
    }
    { print }
  ' "$REPO_ROOT"/modules/captain-cluster/*.tf \
    | grep -oE '^(resource "[a-z0-9_]+" "[a-z0-9_]+"|module "[a-z0-9_]+")' \
    | sed -E 's/^resource "([^"]+)" "([^"]+)"$/\1.\2/; s/^module "([^"]+)"$/module.\1/' \
    | sort -u
}

mode=${1:-}
case $mode in
  split)
    shift
    [ $# -ge 1 ] || { echo "usage: $0 split <environment_name>..." >&2; exit 1; }
    printf 'moved {\n  from = module.tenant_base\n  to   = module.tenant.module.tenant_base\n}\n'
    inventory | while IFS= read -r name; do
      for env in "$@"; do
        printf '\nmoved {\n  from = module.cluster_%s.%s["%s"]\n  to   = module.tenant.module.captain_cluster.%s["%s"]\n}\n' "$env" "$name" "$env" "$name" "$env"
      done
    done
    ;;
  wrapper)
    # invert moved.tf: swap from/to and prefix both with module.tenant.
    # (the tenant repo sees the module's root addresses under module.tenant)
    grep -E '^\s*(from|to)\s*=' "$REPO_ROOT/moved.tf" \
      | sed 's/^ *//' \
      | paste - - \
      | while IFS=$'\t' read -r fromline toline; do
          fromaddr=${fromline#from = }
          toaddr=${toline#to   = }
          printf '\nmoved {\n  from = module.tenant.%s\n  to   = module.tenant.%s\n}\n' "$toaddr" "$fromaddr"
        done
    ;;
  *)
    echo "usage: $0 split <environment_name>... | wrapper" >&2
    exit 1
    ;;
esac
