#!/usr/bin/env bash
# Block credential-shaped values from being committed in .dragon-buddy/*.json.
#
# The buddy profile holds prose: what the project is, how exposed it is, which
# trust boundaries exist. It is committed so the team shares one profile. If a
# real credential ever lands in it, this stops the commit.
#
#   ./.dragon-buddy/scan-config.sh              scan staged content (pre-commit)
#   ./.dragon-buddy/scan-config.sh FILE...      scan files on disk
#
# Exit 0 clean, 1 on a finding, 2 on a usage or environment error.

set -uo pipefail

here=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
detector="$here/scan-config.py"

command -v python3 >/dev/null 2>&1 || {
  echo "scan-config: python3 not found, cannot scan" >&2
  exit 2
}
[ -f "$detector" ] || {
  echo "scan-config: detector missing at $detector" >&2
  exit 2
}

rc=0

if [ "$#" -gt 0 ]; then
  for f in "$@"; do
    [ -f "$f" ] || { echo "scan-config: no such file: $f" >&2; exit 2; }
    python3 "$detector" "$f" <"$f" || rc=1
  done
else
  # Pre-commit mode: scan the staged blob, not the working tree.
  staged=$(git diff --cached --name-only --diff-filter=ACM -- '.dragon-buddy/*.json')
  [ -n "$staged" ] || exit 0
  while IFS= read -r f; do
    [ -n "$f" ] || continue
    git show ":$f" | python3 "$detector" "$f" || rc=1
  done <<<"$staged"
fi

if [ "$rc" -ne 0 ]; then
  cat >&2 <<'MSG'

scan-config: refusing the commit — the buddy profile holds prose, not credentials.
Remove the value, then either re-stage or add .dragon-buddy/config.json to .gitignore.
Override once with: git commit --no-verify
MSG
fi

exit "$rc"
