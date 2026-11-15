# Developer Onboarding & Local Setup Guide

**Project**: Open Source Software Club Website  
**Institution**: Sai Vidya Institute of Technology (SVIT), Bengaluru  
**GitHub Organization**: [Open-Source-Software-Club](https://github.com/Open-Source-Software-Club)  
**Repository**: [OSS_website](https://github.com/Open-Source-Software-Club/OSS_website)  
**Status**: Production-Ready Contributor Specification  

---

## Welcome to the Open Source Software Club!

Welcome! Whether you are a first-time open-source contributor or an experienced developer, this guide provides everything you need to set up your local development environment, run the project, and submit your first pull request.

---

## 1. Prerequisites & Tooling Installation

Before cloning the repository, ensure your development machine has the required tooling installed.

### 1.1 Git Version Control
Verify you have Git version **2.30 or higher**:

```bash
git --version
```

If not installed, install Git for your operating system:
* **Windows**: Download and install from [git-scm.com](https://git-scm.com/download/win) or run:
  ```powershell
  winget install --id Git.Git -e --source winget
  ```
* **macOS**: Install via Homebrew:
  ```bash
  brew install git
  ```
* **Linux (Debian/Ubuntu)**:
  ```bash
  sudo apt update && sudo apt install -y git
  ```

### 1.2 Node.js 18+ (LTS) via NVM
We strictly recommend using **Node Version Manager (nvm)** to ensure version consistency. The project requires Node.js **18.18.0 or 20.x (LTS)**.

* **macOS & Linux**:
  ```bash
  # 1. Install nvm
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash

  # 2. Reload shell configuration
  source ~/.bashrc   # or source ~/.zshrc

  # 3. Install and activate Node 20 LTS
  nvm install 20
  nvm use 20
  nvm alias default 20

  # 4. Verify version
  node --version # should print v20.x.x
  ```

* **Windows**:
  Download and run the installer for [nvm-windows](https://github.com/coreybutler/nvm-windows/releases) or execute:
  ```powershell
  winget install CoreyButler.NVMforWindows
  nvm install 20.11.1
  nvm use 20.11.1
  node --version
  ```

### 1.3 pnpm Package Manager
This project uses **pnpm** (Fast, disk space efficient package manager). Do not use `npm` or `yarn`.

```bash
# Install pnpm globally using npm or Corepack
npm install -g pnpm

# Alternatively, enable via Node's Corepack
corepack enable
corepack prepare pnpm@latest --activate

# Verify installation
pnpm --version # should be >= 8.10.0
```

### 1.4 Recommended VS Code Setup
If you are using Visual Studio Code, install the following recommended extensions:

| Extension Name | Extension ID | Purpose |
| :--- | :--- | :--- |
| **Tailwind CSS IntelliSense** | `bradlc.vscode-tailwindcss` | Autocomplete & linting for Tailwind utility classes |
| **ESLint** | `dbaeumer.vscode-eslint` | Real-time TypeScript & React linting |
| **Prettier - Code formatter** | `esbenp.prettier-vscode` | Code style enforcement on save |
| **Pretty TypeScript Errors** | `yoavbls.pretty-ts-errors` | Human-readable TypeScript diagnostics |
| **GitHub Pull Requests** | `github.vscode-pull-request-github` | Manage PRs and review comments within VS Code |

Add this recommended configuration to your workspace `.vscode/settings.json`:
```json
{
  "editor.defaultFormatter": "esbenp.prettier-vscode",
  "editor.formatOnSave": true,
  "editor.codeActionsOnSave": {
    "source.fixAll.eslint": "explicit"
  },
  "tailwindCSS.experimental.classRegex": [
    ["cva\\(([^)]*)\\)", "[\"'`]([^\"'`]*).*?[\"'`]"],
    ["cn\\(([^)]*)\\)", "[\"'`]([^\"'`]*).*?[\"'`]"]
  ]
}
```

---

## 2. GitHub Account & Authentication Setup

### 2.1 Generating an SSH Key (Recommended)
Using SSH keys eliminates the need to enter credentials on every push.

1. **Generate a new Ed25519 key** in your terminal:
   ```bash
   ssh-keygen -t ed25519 -C "your_email@example.com"
   ```
   *(Press `Enter` to accept default file location and set a secure passphrase).*

2. **Start the ssh-agent and add your key**:
   * macOS / Linux:
     ```bash
     eval "$(ssh-agent -s)"
     ssh-add ~/.ssh/id_ed25519
     ```
   * Windows (PowerShell as Administrator if ssh-agent service is stopped):
     ```powershell
     Get-Service -Name ssh-agent | Set-Service -StartupType Manual
     Start-Service ssh-agent
     ssh-add $env:USERPROFILE\.ssh\id_ed25519
     ```

3. **Copy your public key to clipboard**:
   * macOS: `pbcopy < ~/.ssh/id_ed25519.pub`
   * Linux: `xclip -selection clipboard < ~/.ssh/id_ed25519.pub`
   * Windows (PowerShell): `Get-Content $env:USERPROFILE\.ssh\id_ed25519.pub | Set-Clipboard`

4. **Add the key to GitHub**:
   * Go to **GitHub Settings** -> **SSH and GPG keys** -> **New SSH key**.
   * Paste your key and save.

5. **Test the connection**:
   ```bash
   ssh -T git@github.com
   # Hi username! You've successfully authenticated, but GitHub does not provide shell access.
   ```

*(Alternative: You can use HTTPS with the official GitHub CLI: `gh auth login`).*

---

## 3. Forking, Cloning, and Remote Setup

### 3.1 Step 1: Fork the Repository
Navigate to the official upstream repository:  
[https://github.com/Open-Source-Software-Club/OSS_website](https://github.com/Open-Source-Software-Club/OSS_website)  
Click the **Fork** button (top-right) and create a fork under your personal GitHub account.

### 3.2 Step 2: Clone Your Fork
Clone your personal fork to your local machine:

```bash
# Using SSH (recommended)
git clone git@github.com:<YOUR_GITHUB_USERNAME>/OSS_website.git

# Or using HTTPS
git clone https://github.com/<YOUR_GITHUB_USERNAME>/OSS_website.git

cd OSS_website
```

### 3.3 Step 3: Configure Upstream Remote
Configure the primary club repository as the `upstream` remote so you can stay in sync with ongoing updates:

```bash
git remote add upstream https://github.com/Open-Source-Software-Club/OSS_website.git

# Verify remotes
git remote -v
# origin    git@github.com:<YOUR_USERNAME>/OSS_website.git (fetch)
# origin    git@github.com:<YOUR_USERNAME>/OSS_website.git (push)
# upstream  https://github.com/Open-Source-Software-Club/OSS_website.git (fetch)
# upstream  https://github.com/Open-Source-Software-Club/OSS_website.git (push)
```

---

## 4. Installing Dependencies

Install project packages using `pnpm`:

```bash
pnpm install
```

---

## 5. Environment Configuration

### 5.1 Copy Environment Template
Create your local environment configuration file:

```bash
# On Linux / macOS
cp .env.example .env.local

# On Windows PowerShell
copy .env.example .env.local
```

### 5.2 Environment Variables Reference Table

| Variable Name | Required? | Default / Example | Purpose & Notes |
| :--- | :--- | :--- | :--- |
| `NEXT_PUBLIC_SITE_URL` | **Yes** | `http://localhost:3000` | Canonical site URL for metadata & callbacks |
| `GITHUB_ORG_READ_TOKEN`| **Yes** | `ghp_xxxxxxxxxxxx` | GitHub Personal Access Token to query org statistics |
| `NEXT_PUBLIC_SUPABASE_URL` | Optional | `https://xyzcompany.supabase.co` | Supabase Cloud instance URL |
| `NEXT_PUBLIC_SUPABASE_ANON_KEY` | Optional | `eyJhbGciOi...` | Supabase public client anonymous API key |
| `SUPABASE_SERVICE_ROLE_KEY` | Optional | `eyJhbGciOi...` | Supabase admin key (Never expose in browser) |
| `REVALIDATE_SECRET_TOKEN` | Optional | `dev_revalidate_secret_123` | Secret token to authenticate cache purge webhooks |

> [!NOTE]
> For frontend layout and UI contributions, mock fallbacks are included in the codebase. You only strictly need `GITHUB_ORG_READ_TOKEN` to display live GitHub stats locally.

### 5.3 How to Generate a GitHub Personal Access Token (PAT)
To query repository and contributor metrics from GitHub without hitting low anonymous rate limits:

1. Navigate to **[GitHub Personal Access Tokens](https://github.com/settings/tokens)** (`Settings` -> `Developer settings` -> `Personal access tokens` -> `Tokens (classic)`).
2. Click **Generate new token** -> **Generate new token (classic)**.
3. Set the **Note** to: `OSS Club SVIT Local Dev`.
4. Set **Expiration** to: `90 days`.
5. Select the following read-only scopes:
   - [x] `public_repo` (Access public repositories)
   - [x] `read:org` (Read organization membership and profile)
6. Click **Generate token**.
7. Copy the generated token string (`ghp_...`) immediately and paste it into `.env.local`:
   ```bash
   GITHUB_ORG_READ_TOKEN="ghp_your_actual_token_here"
   ```

### 5.4 Supabase Setup (Optional for Frontend Contributors)
If your task involves database schemas, migrations, or the admin dashboard:
1. Install Supabase CLI:
   ```bash
   pnpm add -D supabase
   ```
2. Initialize and run local Postgres:
   ```bash
   pnpm supabase init
   pnpm supabase start
   ```
3. Copy local API keys printed in your terminal into `.env.local`.

---

## 6. Running the Local Development Server

Start the Next.js development server:

```bash
pnpm dev
```

Open your browser and navigate to:  
**[http://localhost:3000](http://localhost:3000)**

You should see the Open Source Software Club website running locally with fast refresh enabled.

---

## 7. Project Structure Walkthrough

```text
OSS_website/
├── .github/
│   ├── ISSUE_TEMPLATE/        # Bug report & feature request markdown templates
│   ├── PULL_REQUEST_TEMPLATE.md # Standard PR checklist
│   └── workflows/             # CI pipelines (lint, type-check, tests)
├── public/                    # Static assets (favicons, SVIT branding, logos)
├── src/
│   ├── app/                   # Next.js 14 App Router
│   │   ├── (auth)/            # Admin authentication routes
│   │   ├── (public)/          # Public routes (Home, About, Events, Projects)
│   │   ├── api/               # Server-side Route Handlers
│   │   ├── globals.css        # Tailwind directives & CSS variables
│   │   ├── layout.tsx         # Root HTML structure
│   │   └── not-found.tsx      # Custom 404 page
│   ├── components/
│   │   ├── ui/                # Atomic shadcn/ui components (button, card, dialog)
│   │   ├── layout/            # Navbar, MobileNav, Footer, ThemeToggle
│   │   ├── home/              # Hero, Stats Counter, Activity Feed
│   │   ├── projects/          # ProjectCard, FilterBar
│   │   ├── events/            # EventCard, RSVPModal
│   │   └── shared/            # Common UI elements
│   ├── hooks/                 # Custom client React hooks
│   ├── lib/                   # Utility functions, Octokit client, Supabase helpers
│   ├── types/                 # TypeScript interfaces and DB schema definitions
│   └── styles/                # Supplementary design tokens
├── docs/                      # Documentation guides (Architecture, Guidelines, Setup)
├── .env.example               # Template environment variables
├── next.config.mjs            # Next.js runtime configuration & CSP headers
├── package.json               # Project dependencies and npm scripts
├── tailwind.config.ts         # Tailwind design system configuration
└── tsconfig.json              # TypeScript strict configuration
```

For in-depth explanations of system layers and caching lifecycles, read **[docs/architecture.md](./architecture.md)**.

---

## 8. Finding Your First Issue

1. Visit the repository issues tab:  
   [https://github.com/Open-Source-Software-Club/OSS_website/issues](https://github.com/Open-Source-Software-Club/OSS_website/issues)
2. Filter issues by the **`good first issue`** or **`help wanted`** labels.
3. Read the issue description carefully, including expected behavior, target files, and acceptance criteria.
4. **Claim the issue** by posting a comment:
   > *"Hello maintainers! I'd love to work on this issue. Could you please assign it to me?"*
5. **Wait for assignment**: Please wait until a club maintainer assigns the issue to you before opening a pull request. This avoids duplicated work.

---

## 9. Making Changes

### 9.1 Sync with Upstream
Before starting new work, ensure your local `main` branch is up-to-date:

```bash
git checkout main
git fetch upstream
git merge upstream/main
git push origin main
```

### 9.2 Create a Feature Branch
Always create an isolated branch named descriptively:

```bash
# Branch naming format: feat/short-description or fix/issue-number-description
git checkout -b feat/projects-filter-bar

# Or for bug fixes:
git checkout -b fix/issue-42-navbar-overflow
```

### 9.3 Make Focused Changes
* Keep changes scoped strictly to the assigned issue. Avoid unrelated formatting adjustments.
* Follow the design standards outlined in **[docs/design-guidelines.md](./design-guidelines.md)**.

### 9.4 Verification & Quality Checks
Run local checks before staging commits:

```bash
# 1. Run ESLint code checks
pnpm lint

# 2. Verify strict TypeScript types
pnpm type-check

# 3. Format code with Prettier
pnpm format

# 4. Verify production build passes cleanly
pnpm build
```

---

## 10. Committing and Pushing

### 10.1 Conventional Commit Messages
We follow the **Conventional Commits** specification:

* `feat:` A new user-facing feature or component
* `fix:` A bug fix
* `docs:` Documentation improvements
* `style:` Formatting changes that do not affect code logic
* `refactor:` Code restructuring without behavioral changes
* `test:` Adding or adjusting automated tests
* `chore:` Build scripts or dependency updates

**Examples**:
```bash
git add src/components/projects/ProjectCard.tsx
git commit -m "feat(projects): add star counter and topic tags to ProjectCard"

git add docs/development-setup.md
git commit -m "docs: clarify nvm setup commands for Windows developers"
```

### 10.2 Push to Your Fork
Push your local branch to your GitHub fork:

```bash
git push -u origin feat/projects-filter-bar
```

---

## 11. Opening a Pull Request (PR)

1. Navigate to your fork on GitHub: `https://github.com/<YOUR_USERNAME>/OSS_website`.
2. Click the green **Compare & pull request** banner.
3. Ensure the base repository is set to `Open-Source-Software-Club/OSS_website` and base branch is `main`.
4. Complete the PR template:
   * **Summary**: Concise bullet points explaining what changed and why.
   * **Issue Link**: Connect the issue using GitHub keywords (`Closes #42` or `Fixes #42`).
   * **Visual Changes**: If your PR alters UI, attach before/after screenshots or a short GIF.
5. Click **Create pull request**.

---

## 12. Review Process & Iteration

* **Automated CI**: GitHub Actions will automatically run linting, type-checking, and build tests on your PR. If checks fail, click "Details" to view the diagnostic log.
* **Code Review**: A club lead will review your code. Treat review comments as collaborative opportunities to learn and refine the solution.
* **Pushing Updates**: When changes are requested, simply make the edits locally on the same branch and push:
  ```bash
  git add .
  git commit -m "fix: address PR review feedback on button spacing"
  git push origin feat/projects-filter-bar
  ```
  The pull request will automatically update.
* **Approval & Merge**: Once approved and checks pass, maintainers will squash and merge your PR into `main`. Congratulations on your open-source contribution!

---

## 13. Troubleshooting Common Issues

### Issue 1: `pnpm install` Fails or Shows Node Mismatch
* **Symptom**: Error indicating unsupported Node.js version.
* **Fix**: Ensure your active Node runtime is >= 18.18:
  ```bash
  node -v
  nvm use 20
  pnpm store prune
  pnpm install
  ```

### Issue 2: Port 3000 Already in Use
* **Symptom**: `Error: listen EADDRINUSE: address already in use :::3000`
* **Fix**: Either stop the conflicting process or run Next.js on an alternate port:
  ```bash
  pnpm dev -p 3001
  ```

### Issue 3: TypeScript Type Errors on External Packages
* **Symptom**: `Cannot find module ... or its corresponding type declarations.`
* **Fix**: Ensure dependencies are installed and reinstall type definitions:
  ```bash
  pnpm install
  pnpm type-check
  ```

### Issue 4: Environment Variables Not Loading
* **Symptom**: `undefined` when reading environment variables.
* **Fix**:
  1. Ensure the file is named exactly `.env.local` (not `.env.local.txt`).
  2. Variables needed in client components MUST be prefixed with `NEXT_PUBLIC_`.
  3. Restart the dev server after editing `.env.local` (`Ctrl + C`, then `pnpm dev`).

### Issue 5: Merge Conflicts with Upstream `main`
* **Symptom**: GitHub reports your branch has conflicts that must be resolved.
* **Fix**:
  ```bash
  git checkout main
  git fetch upstream
  git merge upstream/main

  git checkout feat/your-branch-name
  git rebase main

  # Resolve any file conflicts marked by Git, stage them:
  git add <resolved-files>
  git rebase --continue

  # Force-push the rebased branch to your personal fork:
  git push --force-with-lease origin feat/your-branch-name
  ```

---

## 14. Getting Help & Club Contacts

Never hesitate to reach out if you get stuck! The club exists to foster learning and mentorship.

* **GitHub Discussions**: Post technical questions or RFCs on the [OSS Website Discussions Board](https://github.com/Open-Source-Software-Club/OSS_website/discussions).
* **Club Community Chat**: Join the official SVIT OSS Club Discord / WhatsApp Community: `[PLACEHOLDER: Insert Club Community Invite URL]`.
* **Lead Maintainers**:
  * Club Faculty Advisor: `[PLACEHOLDER: Faculty Advisor Name & Email]`
  * Student Technical Leads: `[PLACEHOLDER: Student Lead Names & GitHub Handles]`
  * Official Email: `[PLACEHOLDER: oss-club@saividya.ac.in]`
