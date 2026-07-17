#!/usr/bin/env bash
# Generates the moved blocks needed to migrate a tenant repo from the
# backwards-compatible wrapper (module "tenant" calling this repo's root) to
# direct per-cluster module calls (module "tenant_base" + one
# module "cluster_<environment_name>" block per cluster environment).
#
# Usage, from the tenant repo after tofu init:
#   tofu state list | bash generate-moved-blocks.sh > moved-migration.tf
#
# Assumptions:
#   - the old wrapper call is named module "tenant" and is DELETED in the same PR
#     (OpenTofu rejects moved blocks whose "from" is still declared in config)
#   - the new per-cluster blocks are named module "cluster_<environment_name>"
#   - every cluster block passes cluster_environments = [<that one environment>]
#     so all for_each keys keep their environment name
#
# The migration PR's CI plan must show ONLY "has moved" lines and
# "Plan: 0 to add, 0 to change, 0 to destroy." Delete moved-migration.tf in a
# follow-up PR once the migration has applied.
set -euo pipefail

PREFIX='module.tenant.module.captain_cluster'

printf 'moved {\n  from = module.tenant.module.tenant_base\n  to   = module.tenant_base\n}\n'

grep -F "$PREFIX." \
  | grep -F '["' \
  | while IFS= read -r addr; do
      rest=${addr#"$PREFIX".}
      case $rest in
        module.*)
          # nested module call: move the whole module instance, its resources ride along
          inst=$(sed -E 's/^(module\.[A-Za-z0-9_-]+\["[^"]+"\]).*/\1/' <<<"$rest")
          ;;
        *)
          # direct resource instance
          inst=$(sed -E 's/^([A-Za-z0-9_-]+\.[A-Za-z0-9_-]+\["[^"]+"\]).*/\1/' <<<"$rest")
          ;;
      esac
      printf '%s\n' "$inst"
    done \
  | sort -u \
  | while IFS= read -r inst; do
      env=$(sed -E 's/.*\["([^"]+)"\].*/\1/' <<<"$inst")
      printf '\nmoved {\n  from = %s.%s\n  to   = module.cluster_%s.%s\n}\n' "$PREFIX" "$inst" "$env" "$inst"
    done
