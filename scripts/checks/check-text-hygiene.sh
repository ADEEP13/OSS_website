#!/usr/bin/env bash
# ==============================================================================
# check-text-hygiene.sh
#
# Whitespace and encoding hygiene. These are the defects that produce 400-line
# "formatting only" diffs and make `git blame` useless, so they are blocked at
# commit time rather than argued about in review.
#
# Rules (text files only; binaries are skipped):
#   * no trailing whitespace  (two trailing spaces in Markdown = hard break, allowed)
#   * no tab characters
#   * no CRLF line endings    (.gitattributes forces LF)
#   * file ends with exactly one newline
#   * no UTF-8 BOM            (warning only)
#   * no lines longer than 400 characters
#
# Usage:
#   scripts/checks/check-text-hygiene.sh [--staged]
# ==============================================================================
set -uo pipefail

# shellcheck source=lib/common.sh
. "$(dirname "$0")/lib/common.sh"

STAGED=0
for arg in "$@"; do
  case "$arg" in
    --staged) STAGED=1 ;;
    *) printf 'Unknown option: %s\n' "$arg" >&2; exit 2 ;;
  esac
done

log_header "Text hygiene"

MAX_LINE=400

if [ "$STAGED" -eq 1 ]; then
  mapfile -t FILES < <(git diff --cached --name-only --diff-filter=ACM -z 2>/dev/null | tr '\0' '\n')
else
  mapfile -t FILES < <(list_tracked_files)
fi

checked=0

for file in "${FILES[@]:-}"; do
  [ -z "$file" ] && continue
  [ -f "$file" ] || continue

  is_binary_file "$file" && continue
  checked=$((checked + 1))

  # ---- CRLF ------------------------------------------------------------------
  if grep -q $'\r' -- "$file" 2>/dev/null; then
    record_error "$file has CRLF line endings" \
      "'$file' contains CRLF line endings. .gitattributes enforces LF — run 'dos2unix $file' or enable 'files.eol = lf' in your git config."
  fi

  # ---- trailing whitespace ---------------------------------------------------
  # Markdown allows exactly two trailing spaces as an explicit hard break.
  if [[ "$file" == *.md ]]; then
    while IFS= read -r hit; do
      [ -z "$hit" ] && continue
      record_error "$file:${hit%%:*} has trailing whitespace" \
        "'$file' line ${hit%%:*} has trailing whitespace. Markdown only allows a two-space hard break."
    done < <(grep -nE '[[:space:]]$' -- "$file" 2>/dev/null | grep -vE ':[[:space:]]*[0-9]+:[[:space:]]{2}$')
  else
    while IFS= read -r hit; do
      [ -z "$hit" ] && continue
      record_error "$file:${hit%%:*} has trailing whitespace" \
        "'$file' line ${hit%%:*} has trailing whitespace. Configure your editor to trim it on save."
    done < <(grep -nE '[[:space:]]$' -- "$file" 2>/dev/null)
  fi

  # ---- tabs ------------------------------------------------------------------
  # awk is used instead of `grep -P` so the check behaves identically on GNU
  # grep (Linux) and BSD grep (macOS), where -P is unavailable.
  while IFS= read -r hit; do
    [ -z "$hit" ] && continue
    record_error "$file:${hit%%:*} contains a tab character" \
      "'$file' line ${hit%%:*} contains a tab. Use spaces for indentation."
  done < <(awk '/\t/ { printf "%d:%s\n", NR, $0 }' "$file" 2>/dev/null)

  # ---- final newline ---------------------------------------------------------
  if [ -s "$file" ]; then
    last="$(tail -c 1 -- "$file" 2>/dev/null | od -An -c | tr -d ' ')"
    if [ "$last" != '\n' ]; then
      record_error "$file is missing a trailing newline" \
        "'$file' does not end with a newline. POSIX text files end with one."
    fi
    # More than one trailing blank line is also noise.
    trailing_blanks=$(tail -c 4 -- "$file" 2>/dev/null | grep -c '^$' || true)
    if [ "${trailing_blanks:-0}" -gt 1 ]; then
      record_warning "$file ends with multiple blank lines" \
        "'$file' ends with more than one blank line. Trim to a single newline."
    fi
  fi

  # ---- BOM -------------------------------------------------------------------
  if [ "$(head -c 3 -- "$file" 2>/dev/null | od -An -tx1 | tr -d ' \n')" = 'efbbbf' ]; then
    record_warning "$file starts with a UTF-8 BOM" \
      "'$file' begins with a UTF-8 BOM. Remove it — it breaks shebangs, diffs and concatenation."
  fi

  # ---- very long lines -------------------------------------------------------
  while IFS= read -r hit; do
    [ -z "$hit" ] && continue
    record_warning "$file:${hit%%:*} is longer than $MAX_LINE characters" \
      "'$file' line ${hit%%:*} exceeds $MAX_LINE characters."
  done < <(awk -v max="$MAX_LINE" 'length($0) > max { printf "%d:%s\n", NR, $0 }' "$file" 2>/dev/null)
done

log_ok "Checked $checked text file(s)"

finish "Text hygiene check"
