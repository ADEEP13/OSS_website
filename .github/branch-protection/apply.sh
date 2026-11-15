#!/usr/bin/env bash
# ==============================================================================
# .github/branch-protection/apply.sh
#
# Applies the branch protection ruleset defined in ruleset.json to this
# repository, and creates the GitHub environments the deployment workflows need.
#
# Docs: docs/CI_CD.md
#
# Requirements
#   * gh, authenticated as a user with ADMIN access to the repository
#     (an installation token cannot administer branch rulesets)
#   * the CODEOWNERS teams to already exist, or the rule silently does nothing
#
# Usage
#   bash .github/branch-protection/apply.sh            # create or update
#   bash .github/branch-protection/apply.sh --dry-run  # show what would change
#   bash .github/branch-protection/apply.sh --remove   # delete the ruleset
#
# The script is idempotent: running it twice leaves the repository in the same
# state as running it once.
# ==============================================================================
set -euo pipefail

HERE="$(cd "$(dirname "$0")" && pwd)"
RULESET_FILE="$HERE/ruleset.json"

REPO="${GITHUB_REPOSITORY:-$(gh repo view --json nameWithOwner --jq '.nameWithOwner' 2>/dev/null || true)}"
if [ -z "$REPO" ]; then
  echo "apply: could not determine the repository. Set GITHUB_REPOSITORY=owner/name." >&2
  exit 1
fi

DRY_RUN=0
REMOVE=0
for arg in "$@"; do
  case "$arg" in
    --dry-run) DRY_RUN=1 ;;
    --remove)  REMOVE=1 ;;
    -h|--help) sed -n '2,30p' "$0"; exit 0 ;;
    *) echo "Unknown option: $arg" >&2; exit 2 ;;
  esac
done

say() { printf '\n\033[1;34m==>\033[0m %s\n' "$1"; }

if ! command -v gh >/dev/null 2>&1; then
  echo "apply: gh is not installed. https://cli.github.com" >&2
  exit 1
fi

if ! gh auth status >/dev/null 2>&1; then
  echo "apply: gh is not authenticated. Run 'gh auth login'." >&2
  exit 1
fi

say "Repository: $REPO"

# ------------------------------------------------------------------------------
# Verify we can actually administer rulesets. A GitHub App installation token
# gets a 403 here even with admin permission on the repo, which is the single
# most common reason this script appears to "do nothing".
# ------------------------------------------------------------------------------
if ! gh api "repos/$REPO/rulesets" >/dev/null 2>&1; then
  cat >&2 <<'MSG'
apply: cannot read repository rulesets.

This almost always means the token is a GitHub App installation token rather
than a personal access token. Branch rulesets require a PAT (classic, `repo`
scope) or a fine-grained PAT with repository "Administration: read and write".

  gh auth login          # then re-run this script
MSG
  exit 1
fi

# ------------------------------------------------------------------------------
# Remove
# ------------------------------------------------------------------------------
if [ "$REMOVE" -eq 1 ]; then
  id="$(gh api "repos/$REPO/rulesets" --jq '.[] | select(.name == "Protect main") | .id' 2>/dev/null || true)"
  if [ -z "$id" ]; then
    say "No 'Protect main' ruleset found — nothing to remove."
    exit 0
  fi
  if [ "$DRY_RUN" -eq 1 ]; then
    say "Would delete ruleset $id"
    exit 0
  fi
  gh api -X DELETE "repos/$REPO/rulesets/$id" >/dev/null
  say "Deleted ruleset $id"
  exit 0
fi

# ------------------------------------------------------------------------------
# Create or update
# ------------------------------------------------------------------------------
if [ ! -f "$RULESET_FILE" ]; then
  echo "apply: $RULESET_FILE not found." >&2
  exit 1
fi

python3 - "$RULESET_FILE" <<'PY'
import json, sys
with open(sys.argv[1], encoding='utf-8') as fh:
    data = json.load(fh)
# Strip the documentation keys so only real API fields are sent.
data = {k: v for k, v in data.items() if not k.startswith('_')}
with open(sys.argv[1] + '.payload.json', 'w', encoding='utf-8') as fh:
    json.dump(data, fh, indent=2)
print('ruleset.json is valid JSON; payload prepared.')
PY

PAYLOAD="$RULESET_FILE.payload.json"
trap 'rm -f "$PAYLOAD"' EXIT

EXISTING_ID="$(gh api "repos/$REPO/rulesets" --jq '.[] | select(.name == "Protect main") | .id' 2>/dev/null || true)"

if [ "$DRY_RUN" -eq 1 ]; then
  if [ -n "$EXISTING_ID" ]; then
    say "Would UPDATE ruleset $EXISTING_ID from $PAYLOAD"
  else
    say "Would CREATE a new ruleset from $PAYLOAD"
  fi
  cat "$PAYLOAD"
  exit 0
fi

if [ -n "$EXISTING_ID" ]; then
  gh api -X PUT "repos/$REPO/rulesets/$EXISTING_ID" \
    --input "$PAYLOAD" >/dev/null
  say "Updated existing ruleset $EXISTING_ID"
else
  gh api -X POST "repos/$REPO/rulesets" \
    --input "$PAYLOAD" >/dev/null
  say "Created a new ruleset"
fi

# ------------------------------------------------------------------------------
# Environments used by the manual-approval migration workflow.
# ------------------------------------------------------------------------------
for env in production staging; do
  if gh api "repos/$REPO/environments/$env" >/dev/null 2>&1; then
    say "Environment '$env' already exists"
  else
    gh api -X PUT "repos/$REPO/environments/$env" >/dev/null 2>&1 \
      && say "Created environment '$env'" \
      || say "Could not create environment '$env' — create it in repository settings"
  fi
done

cat <<'MSG'

------------------------------------------------------------------------------
Done. Branch protection is now active on the default branch.

What this means in practice:

  * nobody can push to main directly — everything arrives through a pull request
  * a pull request cannot be merged without one approving review
  * CODEOWNERS-protected paths need an approval from a code owner
  * approvals are dismissed when new commits are pushed
  * all review conversations must be resolved
  * merge commits are rejected (linear history), and merges are squash-only
  * branches must be up to date with main before merging
  * the five required status checks must pass
  * force-pushes and branch deletion are blocked
  * commits must be signed

Next steps:

  1. Create the teams referenced in .github/CODEOWNERS, or replace them with
     individual @usernames.
  2. Add required reviewers to the 'production' and 'staging' environments.
  3. Turn on GitHub secret scanning and push protection:
       Settings → Code security → Secret protection
  4. Merge a documentation-only PR to confirm the gate is green.

To see what is applied:
  gh api repos/OWNER/REPO/rulesets --jq '.[].name'

To remove it:
  bash .github/branch-protection/apply.sh --remove
------------------------------------------------------------------------------
MSG
