# .githooks — the hooks that run on your machine

These hooks are the first line of defence in the OSS Club pipeline. They run the
*same* scripts as CI, so what is blocked locally is exactly what is blocked in
the cloud — no drift, no surprises.

## Install

Run once per clone:

```bash
./scripts/install-hooks.sh
```

That sets `core.hooksPath` to `.githooks`. Once `package.json` exists, the same
thing happens automatically on `pnpm install` via the `prepare` script.

## What runs when

| Hook | Trigger | What it blocks |
|---|---|---|
| `pre-commit` | `git commit` | secrets, private keys, `.env` files, foreign lockfiles, build output, oversized files, trailing whitespace, tabs, CRLF, missing final newline |
| `commit-msg` | `git commit` | commit messages that are not Conventional Commits |
| `pre-push` | `git push` | direct pushes to a protected branch, plus every check above across the whole branch |

The pre-push hook is the important one: it is the last thing that runs before
your code becomes visible to everyone else, and on `main` before it reaches
production.

## Bypassing

```bash
git commit --no-verify
git push --no-verify
```

You can. Please don't. CI runs the identical checks and will fail the same pull
request — a bypass only moves the failure from your terminal to a review queue
where someone else has to deal with it.

If a check is genuinely wrong, fix the check or add a reviewed exception:

| Situation | Fix |
|---|---|
| A legitimate file is blocked | add it to `.github/allowed-files.txt` with a comment |
| A legitimate large file is blocked | add it to `.github/large-files.allowlist` with a justification |
| A commit message convention is wrong for your change | use a different Conventional Commits type, or open an issue to discuss the convention |
| A secret pattern is a false positive | add the marker to `PLACEHOLDER_RE` in `scripts/checks/check-secrets.sh` and explain why |

Exceptions to `.github/allowed-files.txt` and `.github/large-files.allowlist`
show up in the pull request diff and are covered by CODEOWNERS, so they are
reviewed like any other change. Editing the glob list inside a check script to
make a build go green is the failure mode this design exists to prevent.

## Removing the hooks

```bash
git config --unset core.hooksPath
```
