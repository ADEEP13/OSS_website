# Starter Backlog (GitHub Issues)

> §12 of the OSS Club Website PRD
> Related docs: [PRD](./PRD.md) · [DEVELOPMENT_ROADMAP](./DEVELOPMENT_ROADMAP.md) · [GITHUB_WORKFLOW](./GITHUB_WORKFLOW.md)

Legend: **B**eginner / **I**ntermediate / **A**dvanced · Skills in brackets.

---

## Epic E0 — Setup (Milestone P0)

| # | Title | Difficulty | Skills | Acceptance criteria |
|---|---|---|---|---|
| 1 | Scaffold Next.js + TS strict + Tailwind + shadcn | A | Next.js, TS | `pnpm dev/build/lint/typecheck/test` pass; folder structure per §4.5 |
| 2 | CI pipeline (verify/db/e2e) | I | GH Actions | Required checks configured; fails on lint error; caches pnpm |
| 3 | Add issue/PR templates, CODEOWNERS, CONTRIBUTING, CoC, SECURITY | B | Markdown | Templates render in "New issue" |
| 4 | Env validation (`lib/env.ts`) + `.env.example` | I | Zod | App fails fast with clear error on missing var; no secret has `NEXT_PUBLIC_` prefix |
| 5 | Branch protection + labels-sync workflow | A | — | Labels in §6.2 exist in all org repos |

---

## Epic E1 — Design system (Milestone P1)

| # | Title | Difficulty | Skills | Acceptance criteria |
|---|---|---|---|---|
| 6 | Tokens + theming (dark/light/system, no flash) | I | CSS, next-themes | Toggle persists; no FOUC; contrast test passes |
| 7 | Fonts + type scale utilities | I | next/font | Instrument Serif/Geist/Geist Mono via `next/font`, CLS 0 |
| 8 | Layout shell: header, mobile sheet nav, footer, skip link | I | React, a11y | Keyboard-complete; focus trap; 360px OK |
| 9 | Button/Badge/Chip/Link-arrow primitives + dev UI page `/dev/ui` | B | React, shadcn | All states shown |
| 10 | Skeleton/Empty/Error/Stale state components | I | React | Used by ≥2 pages |
| 11 | Git-graph scroll line + motion primitives (reduced-motion aware) | A | SVG, motion | 60fps on mid mobile; disabled with reduced motion |
| 12 | Brand: extract logo green, finalise tokens, favicon/OG assets | B | Design | HEX documented in `docs/`; replaces provisional values |

---

## Epic E2 — Core pages (Milestone P1–P2)

| # | Title | Difficulty | Skills | Acceptance criteria |
|---|---|---|---|---|
| 13 | Home hero + live terminal panel (static data first) | A | React, CSS | Terminal renders real cache data; static fallback for reduced motion |
| 14 | Home sections 2–9 per §7.3 | I | React, ISR | All sections render with empty states; ISR 60s |
| 15 | About page (content TBD placeholders marked) | B | React | Placeholder content clearly marked |
| 16 | Join page + form + `join_applications` table + Turnstile | I | React, Supabase | Form validates; submits to DB; captcha blocks bots |
| 17 | Contact page | B | React | Form with honeypot + Turnstile; sends to admin |

---

## Epic E3 — Content data (Milestone P2)

| # | Title | Difficulty | Skills | Acceptance criteria |
|---|---|---|---|---|
| 18 | Migrations: content tables + triggers + seed | I | SQL, Supabase | `supabase db reset` clean |
| 19 | RLS policies + pgTAP tests for content tables | A | SQL, pgTAP | Anon can't read drafts; member can't write |
| 20 | Projects index + detail from DB | I | React, Supabase | Filter/search works; detail shows README |
| 21 | Events list/detail | I | React, Supabase | Upcoming/past grouping; registration link |
| 22 | Learning tracks + markdown renderer (sanitised) | I | React, rehype | Markdown renders safely; TOC generated |
| 23 | Team page | B | React, Supabase | Groups displayed; only visible=true entries |

---

## Epic E4 — GitHub integration (Milestone P3)

| # | Title | Difficulty | Skills | Acceptance criteria |
|---|---|---|---|---|
| 24 | Create GitHub App + token service (`lib/github/app.ts`) | A | Octokit, JWT | Installation token fetched, cached, refreshed; unit tests mock Octokit |
| 25 | Webhook endpoint with HMAC + dedupe | A | Crypto, API | Bad signature 401; replay no-op; test fixtures for each event |
| 26 | GraphQL full sync → `gh_repos/gh_issues/gh_pulls` with label→metadata parser | A | GraphQL, SQL | Unit-tested for all taxonomy cases |
| 27 | Reconcile endpoint + scheduler + `sync_state` | A | Cron, API | Idempotent; handles rate limits; updates `sync_state` |
| 28 | Admin GitHub health page | I | React | Shows last webhook, last reconcile, rate-limit remaining |

---

## Epic E5 — Contribution portal (Milestone P4)

| # | Title | Difficulty | Skills | Acceptance criteria |
|---|---|---|---|---|
| 29 | Issue list + URL-synced filters + full-text search | I | React, SQL | Filters sync to URL; search uses `tsvector`; pagination works |
| 30 | Issue detail page (sanitised preview) | I | React, rehype | Markdown safe; skills shown; CTAs work |
| 31 | PR feed | I | React | Displays open/merged PRs; links to GitHub |
| 32 | Freshness/stale chips | B | React | Shows synced_at; amber warning if stale |
| 33 | Repo search on Projects | I | React, SQL | Search projects by name/language/status |

---

## Epic E6 — Auth & admin (Milestone P5)

| # | Title | Difficulty | Skills | Acceptance criteria |
|---|---|---|---|---|
| 34 | Supabase GitHub login + profile bootstrap + org-membership check | A | Supabase Auth | Login works; profile created; org member flag set |
| 35 | RBAC (`user_roles`, `requireRole`, middleware) + tests | A | Auth, RLS | All roles enforced; tests cover anon/member/admin |
| 36 | Admin CRUD: projects/events/resources/announcements/team | I | React, Server Actions | Create/edit/delete/publish for all content types |
| 37 | Contribution requests flow + maintainer queue | I | React, Supabase | Interest sent; maintainer sees queue; approve/decline works |
| 38 | Issue proposals → approve → create GitHub issue (idempotent) | A | Octokit, Zod | Proposal created; admin approves; GitHub issue created; no duplicates |
| 39 | Audit log writer + viewer | I | SQL, React | All admin actions logged; admin can view logs |

---

## Epic E7 — Recognition & analytics (Milestone P6)

| # | Title | Difficulty | Skills | Acceptance criteria |
|---|---|---|---|---|
| 40 | Profiles + privacy settings | I | React, Supabase | Opt-in public profile; privacy toggles work |
| 41 | Achievement engine (recomputable) | A | SQL, GitHub API | Awards based on merged PRs; recomputable from GitHub |
| 42 | Analytics events + admin dashboard | I | React, SQL | Custom events tracked; admin overview shows metrics |

---

## Epic E8 — Launch (Milestone P7)

| # | Title | Difficulty | Skills | Acceptance criteria |
|---|---|---|---|---|
| 43 | Playwright E2E for P0 stories | I | Playwright | All P0 user stories covered |
| 44 | axe + manual a11y audit | I | axe, NVDA | Zero critical violations; WCAG 2.2 AA compliant |
| 45 | Lighthouse CI + perf fixes | I | Lighthouse | Perf ≥ 90, a11y ≥ 95, SEO ≥ 90 |
| 46 | SEO: metadata, sitemap, robots, JSON-LD | B | Next.js | All routes have metadata; sitemap generated; JSON-LD valid |
| 47 | Runbooks (key rotation, webhook redelivery, restore) | I | Docs | Documented procedures for all operational scenarios |

---

## Sample fully-written issue (template for the rest)

```markdown
Title: [A] Webhook endpoint with HMAC verification and delivery dedupe

Problem: GitHub changes must reach our cache within a minute without trusting unsigned requests.

Objective: Secure /api/webhooks/github that verifies every delivery, prevents replays, and upserts
into gh_* cache tables.

Scope:
- IN: HMAC-SHA256 verification, delivery dedupe via webhook_deliveries table, event routing for
  issues/pull_request/repository/label/member/organization, upsert into gh_repos/gh_issues/gh_pulls,
  update contribution_requests on assignee/PR events
- OUT: Issue creation (separate issue), achievement computation (triggered but not implemented here)

Implementation guidance:
- File: src/app/api/webhooks/github/route.ts
- Use crypto.timingSafeEqual for HMAC comparison
- Read raw body (not parsed JSON) for signature verification
- Insert X-GitHub-Delivery into webhook_deliveries (PK) before processing
- Route by X-GitHub-Event header to handler functions in src/features/contribute/webhooks/
- Each handler should be a pure function: (payload, supabase) => Promise<void>
- Return 200 within 10s; defer heavy work

Acceptance criteria:
- [ ] Given a valid webhook with correct signature, When received, Then data is upserted and 200 returned
- [ ] Given an invalid signature, When received, Then 401 returned and no data modified
- [ ] Given a duplicate X-GitHub-Delivery, When received, Then 200 returned with no re-processing
- [ ] Given an issues.opened event, When processed, Then gh_issues row created with correct label mapping
- [ ] Given a pull_request.closed(merged) event for a tracked request, Then contribution_requests
      status updated to 'merged'

Dependencies: #18 (DB tables), #24 (GitHub App token service)
Difficulty: Advanced
Required skills: Node.js crypto, webhook security, Supabase server client
Labels: area: backend, type: feature, difficulty: advanced, priority: high
Milestone: P3 - GitHub Integration
Testing: Unit tests with fixture payloads for each event type; integration test with Supabase
Docs: Update GITHUB_INTEGRATION.md with webhook handler architecture
```
