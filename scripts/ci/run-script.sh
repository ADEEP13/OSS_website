#!/usr/bin/env bash
# ==============================================================================
# scripts/ci/run-script.sh
#
# Runs a package.json script if it exists, and reports a GitHub Actions warning
# (not a failure) if it does not.
#
# Why this exists
#   The pipeline must be able to require the "Verify" status check from the very
#   first commit, before package.json exists and before every convention the
#   README documents has been settled. A missing script is therefore a warning
#   so a greenfield repository is not blocked, while a *failing* script is still
#   a hard failure the moment it exists.
#
# Usage:
#   run-script.sh <name> [extra args passed to pnpm run ...]
#
# Examples:
#   run-script.sh lint
#   run-script.sh test -- --coverage
# ==============================================================================
set -uo pipefail

if [ "$#" -lt 1 ]; then
  echo "usage: $0 <script-name> [args...]" >&2
  exit 2
fi

NAME="$1"
shift

if [ ! -f package.json ]; then
  echo "::warning::package.json not found — skipping '$NAME'."
  exit 0
fi

if node -e "const s=require('./package.json').scripts||{}; process.exit(s['$NAME']?0:1)"; then
  echo "::group::pnpm run $NAME $*"
  # shellcheck disable=SC2086
  pnpm run "$NAME" "$@"
  rc=$?
  echo "::endgroup::"
  exit "$rc"
fi

echo "::warning::package.json has no '$NAME' script — skipping this verification step."
exit 0
