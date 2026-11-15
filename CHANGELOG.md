# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [Unreleased]

### Added
- Interactive calendar view for upcoming workshops and hackathons in `src/app/(main)/events`.
- Supabase Row Level Security (RLS) policies for student project submissions.
- GitHub API integration to automatically fetch star counts and contributor avatars for featured club repositories.
- Newsletter subscription form component with Supabase database persistence.
- Breadcrumbs component for nested documentation and blog pages.

### Changed
- Refactored `ProjectCard` component to support dynamic language color tags.
- Optimized hero section animations for low-power mobile devices.

### Fixed
- Fixed layout shift (CLS) in navigation bar during dark/light theme hydration.
- Resolved mobile drawer menu failing to trap focus when opened.

---

## [0.1.0] - 2024-04-15

### Added
- **Core Architecture & Scaffolding:**
  - Initial project bootstrap using Next.js 14 App Router with React Server Components (RSC).
  - TypeScript 5 strict configuration (`strict: true`) and path aliases (`@/*`).
  - Tailwind CSS 3.4 configuration with custom SVIT brand colors and dark/light mode palette.
  - Integration of `shadcn/ui` primitives (Button, Card, Dialog, DropdownMenu, Avatar, Badge, Input, Form) powered by Radix UI.
  - Theme provider integration using `next-themes` with zero flash on load.
- **Pages & Routes:**
  - Responsive Homepage (`src/app/page.tsx`) with hero banner, club metrics counter, featured projects carousel, and core team teaser.
  - About Page (`src/app/(main)/about/page.tsx`) detailing club history, faculty coordinator message, mission, and leadership directory.
  - Events Directory (`src/app/(main)/events/page.tsx`) with category filtering (Hackathons, Workshops, Study Jams) and RSVP modal.
  - Projects Directory (`src/app/(main)/projects/page.tsx`) showcasing student open-source repositories with direct GitHub and live demo links.
  - Contributors Page (`src/app/(main)/contributors/page.tsx`) with automated GitHub contributor grid.
  - Custom branded 404 Not Found page (`src/app/not-found.tsx`).
- **Database & Authentication:**
  - Supabase client integration (`src/lib/supabase/client.ts` and `src/lib/supabase/server.ts`).
  - Initial PostgreSQL database migration schema for `events`, `projects`, and `club_members`.
  - Row Level Security (RLS) policies enabling public reads and authenticated admin writes.
- **Tooling & Developer Experience:**
  - ESLint ruleset tailored for Next.js App Router and TypeScript best practices.
  - Prettier configuration with `prettier-plugin-tailwindcss` for automated class sorting.
  - GitHub Actions CI workflow (`.github/workflows/ci.yml`) enforcing type checking, linting, formatting, and build verification on all pull requests.
  - Comprehensive `.env.example` file documenting all environment variable requirements.
- **Repository Documentation:**
  - Production-ready `README.md` with installation guides, architecture overview, and badges.
  - Comprehensive `CONTRIBUTING.md` including Git workflow, branch naming, Conventional Commits, and testing guidelines.
  - `CODE_OF_CONDUCT.md` based on Contributor Covenant v2.1.
  - Responsible disclosure `SECURITY.md` policy.
  - Open-source `LICENSE` (MIT).

[Unreleased]: https://github.com/Open-Source-Software-Club/OSS_website/compare/v0.1.0...HEAD
[0.1.0]: https://github.com/Open-Source-Software-Club/OSS_website/releases/tag/v0.1.0
