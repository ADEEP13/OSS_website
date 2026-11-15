#!/usr/bin/env bash
# ==============================================================================
# Shared helpers for the OSS Club repository quality checks.
#
# Every script in this directory is intentionally dependency-free (bash + git +
# grep) so that the exact same checks can run:
#   * locally, inside .githooks/pre-commit|pre-push  (developer machine)
#   * in CI, inside .github/workflows/ci.yml         (GitHub Actions runner)
#
# Sourced by all check scripts. Never executed directly.
# ==============================================================================

# ------------------------------------------------------------------------------
# Output helpers
# ------------------------------------------------------------------------------
if [ -t 1 ] && [ -z "${NO_COLOR:-}" ]; then
  C_RESET='\033[0m'; C_RED='\033[1;31m'; C_GREEN='\033[1;32m'
  C_YELLOW='\033[1;33m'; C_BLUE='\033[1;34m'; C_DIM='\033[2m'
else
  C_RESET=''; C_RED=''; C_GREEN=''; C_YELLOW=''; C_BLUE=''; C_DIM=''
fi

log_header() { printf '\n%s==>%s %s\n' "$C_BLUE" "$C_RESET" "$1"; }
log_ok()     { printf '  %s✓%s %s\n' "$C_GREEN" "$C_RESET" "$1"; }
log_warn()   { printf '  %s!%s %s\n' "$C_YELLOW" "$C_RESET" "$1"; }
log_fail()   { printf '  %s✗%s %s\n' "$C_RED" "$C_RESET" "$1"; }

# GitHub Actions workflow commands. No-op (but harmless) outside Actions.
gha_error()   { echo "::error::$1"; }
gha_warning() { echo "::warning::$1"; }
gha_notice()  { echo "::notice::$1"; }

# ------------------------------------------------------------------------------
# Repository root — scripts may be invoked from a hook (repo root) or from
# anywhere else, so resolve it from git rather than $PWD.
# ------------------------------------------------------------------------------
REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
cd "$REPO_ROOT" || exit 1

# Path of the allowlist files (reviewable in git, owned by CODEOWNERS).
ALLOWED_FILES_LIST=".github/allowed-files.txt"
LARGE_FILES_LIST=".github/large-files.allowlist"

# Human-readable byte size, portable across GNU and BSD.
human_size() {
  local bytes="$1"
  if [ "$bytes" -ge $((1024 * 1024)) ]; then
    awk -v b="$bytes" 'BEGIN { printf "%.1f MiB", b / 1048576 }'
  elif [ "$bytes" -ge 1024 ]; then
    awk -v b="$bytes" 'BEGIN { printf "%.1f KiB", b / 1024 }'
  else
    printf '%s B' "$bytes"
  fi
}

# ------------------------------------------------------------------------------
# Tracked file enumeration
# ------------------------------------------------------------------------------
# `git ls-files -z` is authoritative: it lists exactly what git would commit,
# which is precisely what we want to police.
list_tracked_files() {
  git ls-files -z 2>/dev/null | tr '\0' '\n'
}

# ------------------------------------------------------------------------------
# Binary detection — text-only checks must not run against images or fonts.
# ------------------------------------------------------------------------------
BINARY_EXTENSIONS='png|jpg|jpeg|gif|webp|avif|bmp|ico|icns|pdf|woff|woff2|ttf|otf|eot|mp3|mp4|webm|mov|zip|gz|tgz|tar|rar|7z|wasm|snap|jpeg'

is_binary_file() {
  local f="$1" chunk raw stripped
  case "${f##*.}" in
    png|jpg|jpeg|gif|webp|avif|bmp|ico|icns|pdf|woff|woff2|ttf|otf|eot|mp3|mp4|webm|mov|zip|gz|tgz|tar|rar|7z|wasm)
      return 0 ;;
  esac
  # Fallback: a NUL byte anywhere in the first 8 KB means "binary".
  # `tr -d '\000'` is used rather than `grep -q $'\x00'` because a shell cannot
  # pass a NUL byte inside an argument, which would silently match everything.
  chunk="$(head -c 8000 -- "$f" 2>/dev/null || true)"
  raw="${#chunk}"
  stripped="$(printf '%s' "$chunk" | tr -d '\000' | wc -c | tr -d ' ')"
  if [ "$raw" -ne "$stripped" ]; then
    return 0
  fi
  return 1
}

# ------------------------------------------------------------------------------
# Allowlists
# ------------------------------------------------------------------------------
# Reads a newline-delimited allowlist file into the global array
# ALLOWLIST_PATTERNS, ignoring blank lines and `#` comments.
load_allowlist() {
  local file="$1"
  ALLOWLIST_PATTERNS=()
  [ -f "$file" ] || return 0
  local line
  while IFS= read -r line || [ -n "$line" ]; do
    line="${line%%$'\r'}"
    case "$line" in ''|'#'*) continue ;; esac
    ALLOWLIST_PATTERNS+=("$line")
  done < "$file"
}

# True when $1 matches any entry of the loaded allowlist.
is_allowlisted() {
  local candidate="$1" pat
  for pat in "${ALLOWLIST_PATTERNS[@]:-}"; do
    [ -z "$pat" ] && continue
    # shellcheck disable=SC2053
    if [[ "$candidate" == $pat ]]; then
      return 0
    fi
  done
  return 1
}

# ------------------------------------------------------------------------------
# Failure accumulator
#
# Checks never `exit 1` on the first problem: they collect everything and print
# one complete report. Reviewers fix a whole list in one pass instead of
# playing whack-a-mole across CI runs.
# ------------------------------------------------------------------------------
ERRORS=0
WARNINGS=0

record_error()   { ERRORS=$((ERRORS + 1)); log_fail "$1"; gha_error "$2"; }
record_warning() { WARNINGS=$((WARNINGS + 1)); log_warn "$1"; gha_warning "$2"; }

finish() {
  local label="$1"
  if [ "$ERRORS" -gt 0 ]; then
    printf '\n%s%s FAILED%s — %s error(s), %s warning(s).\n' \
      "$C_RED" "$label" "$C_RESET" "$ERRORS" "$WARNINGS"
    exit 1
  fi
  printf '\n%s%s PASSED%s — %s warning(s).\n' "$C_GREEN" "$label" "$C_RESET" "$WARNINGS"
  exit 0
}
