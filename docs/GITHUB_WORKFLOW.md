# Development Workflow

> §11 of the OSS Club Website PRD
> Related docs: [PRD](./PRD.md) · [ARCHITECTURE](./ARCHITECTURE.md) · [GITHUB_ISSUES](./GITHUB_ISSUES.md)

---

## Branching strategy

Trunk-based development.

- `main` is protected
- Feature branches: `feat/<area>-<short>`, `fix/…`, `docs/…`, `chore/…`
- Issue number referenced in PR body

---

## Commit conventions

[Conventional Commits](https://www.conventionalcommits.org/) enforced by commitlint (PR title lint since we squash-merge).

Examples:
- `feat(contribute): add difficulty filter`
- `fix(auth): handle expired GitHub token gracefully`
- `docs: update ARCHITECTURE.md with webhook flow`

---

## Pull request rules

- **1 approval** required (2 for `lib/github`, `supabase/migrations`, `lib/rbac` via CODEOWNERS)
- All CI checks green
- Up-to-date with `main`
- Linear history (squash merge)
- All conversations resolved
- No force-push to `main`

### PR template checklist

- Linked issue
- Screenshots/video for UI changes
- Test notes
- Accessibility checklist
- Migration note (if applicable)

---

## Projects board

| Column | Description |
|---|---|
| Backlog | Triaged but not started |
| Ready | Dependencies met, can be picked up |
| In progress | Actively being worked on |
| In review | PR open, awaiting review |
| Done | Merged to main |

**Fields:** Epic, Phase, Difficulty, Area, Size

**Milestones** = Phases 0–7

**Epics** = Parent issues with sub-issues

---

## Issue templates (YAML forms)

Every dev issue includes:

1. **Title**
2. **Problem** — what's wrong or missing
3. **Objective** — what success looks like
4. **Scope** (in/out)
5. **Implementation guidance** — actual file paths, component names, specific instructions
6. **Acceptance criteria** (Given/When/Then)
7. **Dependencies** — other issue numbers
8. **Difficulty** — Beginner / Intermediate / Advanced
9. **Required skills**
10. **Labels** — from taxonomy in [GITHUB_INTEGRATION.md](./GITHUB_INTEGRATION.md)
11. **Testing requirements**
12. **Docs requirements**

### Template types

| Template | Extra fields |
|---|---|
| Feature | — |
| Bug | Repro steps, expected/actual, environment |
| UI/UX | Design reference, viewport |
| Documentation | Target audience |
| Tech debt | Impact, effort |
| Integration | API/permission/rate-limit fields |

---

## Task distribution by difficulty

| Difficulty | Suitable tasks |
|---|---|
| **Beginner** | Static pages, content components, docs, copy, seed data, a11y fixes |
| **Intermediate** | Filters, forms, admin CRUD screens, tests |
| **Advanced** | GitHub App, sync/webhooks, RLS, authz, CI/CD, performance |

**Rule:** each issue touches one `features/*` module.

---

## CI pipeline (`.github/workflows/ci.yml`)

```yaml
name: ci
on: { pull_request: {}, push: { branches: [main] } }
concurrency: { group: ci-${{ github.ref }}, cancel-in-progress: true }
jobs:
  verify:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: pnpm/action-setup@v4
      - uses: actions/setup-node@v4
        with: { node-version: 22, cache: pnpm }
      - run: pnpm install --frozen-lockfile
      - run: pnpm lint && pnpm typecheck
      - run: pnpm test --run
      - run: pnpm build
        env: { NEXT_PUBLIC_SITE_URL: http://localhost:3000, SKIP_ENV_VALIDATION: "1" }
  db:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: supabase/setup-cli@v1
      - run: supabase db start && supabase db reset && supabase test db
  e2e:
    needs: verify
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: pnpm/action-setup@v4
      - uses: actions/setup-node@v4
        with: { node-version: 22, cache: pnpm }
      - run: pnpm install --frozen-lockfile && pnpm exec playwright install --with-deps chromium
      - run: pnpm e2e
```

### Deployment integration

- **Vercel** native Git integration for Preview (every PR) and Production (`main`) deploys
- GitHub Actions is the **quality gate** (branch protection requires `verify`, `db`, `e2e`, + Vercel check)
- Don't duplicate deploys from Actions
- **Database migrations:** applied to prod by a manual-approval workflow (`supabase db push`) — never auto from PR
