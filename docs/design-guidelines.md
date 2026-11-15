# Design Guidelines & UI System

**Project**: Open Source Software Club Website  
**Institution**: Sai Vidya Institute of Technology (SVIT), Bengaluru  
**GitHub Organization**: [Open-Source-Software-Club](https://github.com/Open-Source-Software-Club)  
**Repository**: [OSS_website](https://github.com/Open-Source-Software-Club/OSS_website)  
**Status**: Production-Ready Design Specification  

---

## 1. Design Philosophy

The Open Source Software Club website embodies modern developer-centric design aesthetics, inspired by the polish, precision, and performance of industry benchmarks such as Linear, Vercel, and GitHub.

### Core Principles
1. **Developer First & Content Driven**: Information takes center stage. Repositories, code snippets, workshop dates, and contributor stats must be immediately readable without visual clutter.
2. **Intentional Minimalism**: Every border, gradient, and shadow serves a functional purpose (e.g., establishing visual hierarchy, separating interactive regions, or indicating active states).
3. **High Contrast & Readability**: Crisp text contrast across both dark and light modes, with dark mode treated as the primary default experience for developer audiences.
4. **Subtle Tactility**: Smooth, lightweight transitions, glassmorphic header blur, micro-interactions on hover, and accessible keyboard focus states that feel responsive and tactile.
5. **Radical Performance**: Pure CSS transitions over heavy JavaScript animation runtimes, respecting system motion preferences and bandwidth limitations.

---

## 2. Brand Identity Guidelines

### 2.1 Brand Concept & Metaphors
The Open Source Software Club at Sai Vidya Institute of Technology represents collaborative engineering, open knowledge sharing, and collegiate technical excellence.
* **Metaphors**: Terminal command line interfaces, Git commit graphs, branch merges (`git merge`), brackets (`{ }`, `</>`), and interconnected node networks.
* **Tone of Voice**: Clear, inclusive, engineering-focused, inspiring, and professional. Avoid corporate buzzwords; speak directly to student developers and contributors.

### 2.2 Logo Usage
* **Primary Mark**: The OSS SVIT glyph combines an open terminal cursor/bracket with a branch node icon.
* **Monochrome Reproduction**: The logo must remain legible as a pure white mark on dark backgrounds and a deep slate mark on light backgrounds.
* **Clear Space**: Maintain a minimum clear space surrounding the logo equal to 50% of the logo's height.
* **Do Not**: Stretch, distort, apply drop shadows to the raw glyph, or alter the brand gradient angle.

---

## 3. Color System

The website features an adaptive color palette designed for high contrast and developer comfort. **Dark mode is the default theme**.

### 3.1 Color Palette Specifications

#### Dark Theme (Default)

| Token Name | Hex Code | HSL Value | Usage Description |
| :--- | :--- | :--- | :--- |
| **Background** | `#09090b` | `240 10% 3.9%` | Main canvas, root background |
| **Surface** | `#18181b` | `240 5.9% 10%` | Cards, elevated containers, modal panels |
| **Surface Elevated** | `#27272a` | `240 5.2% 16.5%`| Dropdowns, tooltips, popovers |
| **Border** | `#27272a` | `240 5.2% 16.5%`| Card borders, dividers, table rules |
| **Border Subtle** | `rgba(255,255,255,0.08)` | - | Glassmorphism outer stroke |
| **Text Primary** | `#fafafa` | `0 0% 98%` | Headings, titles, high-emphasis text |
| **Text Secondary** | `#a1a1aa` | `240 5% 64.9%` | Body copy, descriptions, captions |
| **Text Muted** | `#71717a` | `240 3.8% 46.1%`| Timestamps, meta icons, disabled text |
| **Accent Primary** | `#6366f1` | `239 84% 67%` | Indigo-500: Primary CTAs, active links |
| **Accent Primary Hover** | `#4f46e5` | `243 75% 59%` | Indigo-600: Hover state for primary buttons |
| **Accent Secondary** | `#8b5cf6` | `258 90% 66%` | Violet-500: Secondary gradients, badges |
| **Success** | `#22c55e` | `142 71% 45%` | Green-500: Merged PRs, upcoming events, online |
| **Warning** | `#eab308` | `48 96% 53%` | Yellow-500: Issues needing triage, limited seats |
| **Error / Destructive** | `#ef4444` | `0 84.2% 60.2%` | Red-500: Closed PRs, cancelled events, errors |

#### Light Theme

| Token Name | Hex Code | HSL Value | Usage Description |
| :--- | :--- | :--- | :--- |
| **Background** | `#ffffff` | `0 0% 100%` | Main canvas, root background |
| **Surface** | `#f4f4f5` | `240 4.8% 95.9%`| Cards, light panels, code containers |
| **Surface Elevated** | `#ffffff` | `0 0% 100%` | Dropdowns, popovers with medium shadow |
| **Border** | `#e4e4e7` | `240 5.9% 90%` | Card borders, dividers, input outlines |
| **Text Primary** | `#09090b` | `240 10% 3.9%` | Headings, titles, high-emphasis text |
| **Text Secondary** | `#71717a` | `240 3.8% 46.1%`| Body copy, descriptions |
| **Text Muted** | `#a1a1aa` | `240 5% 64.9%` | Captions, subtle metadata |
| **Accent Primary** | `#6366f1` | `239 84% 67%` | Indigo-500 |
| **Accent Secondary** | `#8b5cf6` | `258 90% 66%` | Violet-500 |
| **Success** | `#16a34a` | `142 76% 36%` | Green-600 (Darker for 4.5:1 light contrast) |
| **Warning** | `#ca8a04` | `42 94% 40%` | Yellow-600 |
| **Error / Destructive** | `#dc2626` | `0 72% 51%` | Red-600 |

### 3.2 CSS Variables Mapping (`globals.css`)

```css
@layer base {
  :root {
    --background: 0 0% 100%;
    --foreground: 240 10% 3.9%;
    --card: 240 4.8% 95.9%;
    --card-foreground: 240 10% 3.9%;
    --popover: 0 0% 100%;
    --popover-foreground: 240 10% 3.9%;
    --primary: 239 84% 67%;
    --primary-foreground: 0 0% 98%;
    --secondary: 240 4.8% 95.9%;
    --secondary-foreground: 240 5.9% 10%;
    --muted: 240 4.8% 95.9%;
    --muted-foreground: 240 3.8% 46.1%;
    --accent: 258 90% 66%;
    --accent-foreground: 0 0% 98%;
    --destructive: 0 72% 51%;
    --destructive-foreground: 0 0% 98%;
    --border: 240 5.9% 90%;
    --input: 240 5.9% 90%;
    --ring: 239 84% 67%;
    --radius: 0.5rem;
  }

  .dark {
    --background: 240 10% 3.9%;
    --foreground: 0 0% 98%;
    --card: 240 5.9% 10%;
    --card-foreground: 0 0% 98%;
    --popover: 240 5.2% 16.5%;
    --popover-foreground: 0 0% 98%;
    --primary: 239 84% 67%;
    --primary-foreground: 0 0% 98%;
    --secondary: 240 3.7% 15.9%;
    --secondary-foreground: 0 0% 98%;
    --muted: 240 3.7% 15.9%;
    --muted-foreground: 240 5% 64.9%;
    --accent: 258 90% 66%;
    --accent-foreground: 0 0% 98%;
    --destructive: 0 84.2% 60.2%;
    --destructive-foreground: 0 0% 98%;
    --border: 240 5.2% 16.5%;
    --input: 240 5.2% 16.5%;
    --ring: 239 84% 67%;
  }
}
```

---

## 4. Typography

Typography is powered by Google Fonts loaded natively via `next/font/google`.

### 4.1 Font Families
* **Display & Headings**: `Inter` (or optional geometric variant `Outfit` for large hero titles)
* **Body & UI**: `Inter` (weights: Regular 400, Medium 500, Semi-Bold 600, Bold 700)
* **Code & Monospace**: `JetBrains Mono` or `Fira Code` (weights: Regular 400, Medium 500)

### 4.2 Type Scale & Hierarchy

| Element | Size (px) | Size (rem) | Line Height | Letter Spacing | Tailwind Class | Weight |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **Display / Hero** | 72px | 4.5rem | 1.1 | -0.025em | `text-7xl font-bold tracking-tight` | 700 / 800 |
| **Heading 1 (H1)** | 48px | 3.0rem | 1.15 | -0.02em | `text-5xl font-bold tracking-tight` | 700 |
| **Heading 2 (H2)** | 36px | 2.25rem | 1.2 | -0.015em | `text-4xl font-semibold tracking-tight`| 600 |
| **Heading 3 (H3)** | 30px | 1.875rem | 1.25 | -0.01em | `text-3xl font-semibold` | 600 |
| **Heading 4 (H4)** | 24px | 1.5rem | 1.3 | 0em | `text-2xl font-semibold` | 600 |
| **Subheading** | 20px | 1.25rem | 1.4 | 0em | `text-xl font-medium` | 500 |
| **Body Large** | 18px | 1.125rem | 1.5 | 0em | `text-lg font-normal` | 400 |
| **Body Default** | 16px | 1.0rem | 1.5 | 0em | `text-base font-normal` | 400 |
| **Body Small** | 14px | 0.875rem | 1.4 | 0em | `text-sm font-normal` | 400 / 500 |
| **Caption / Meta** | 12px | 0.75rem | 1.4 | 0.02em | `text-xs font-medium uppercase tracking-wider` | 500 |
| **Code Block** | 14px | 0.875rem | 1.6 | 0em | `font-mono text-sm` | 400 |

---

## 5. Spacing System

A strict **4px modular grid** guides all layout dimensions, margins, paddings, and gap distances.

| Value (px) | Value (rem) | Tailwind Key | Standard Usage |
| :--- | :--- | :--- | :--- |
| **4px** | 0.25rem | `1` | Micro padding, icon gap, badge internal padding |
| **8px** | 0.5rem | `2` | Button inner vertical padding, tight list spacing |
| **12px** | 0.75rem | `3` | Input field vertical padding, small card gap |
| **16px** | 1.0rem | `4` | Card internal padding (mobile), standard button horizontal padding |
| **20px** | 1.25rem | `5` | Medium container gap |
| **24px** | 1.5rem | `6` | Standard desktop card padding, grid gap |
| **32px** | 2.0rem | `8` | Section sub-group spacing, table cell padding |
| **40px** | 2.5rem | `10` | Form field group spacing |
| **48px** | 3.0rem | `12` | Mobile section vertical padding |
| **64px** | 4.0rem | `16` | Standard section vertical spacing |
| **80px** | 5.0rem | `20` | Large section separator |
| **96px** | 6.0rem | `24` | Hero section vertical padding |
| **128px** | 8.0rem | `32` | Landing page major content breaks |

---

## 6. Border Radius & Shadows

### 6.1 Border Radius Scale
* `rounded-sm`: **4px** — Small badges, code tags, tooltips.
* `rounded`: **6px** — Input fields, sub-buttons, dropdown items.
* `rounded-md`: **8px** — Standard buttons, alert banners.
* `rounded-lg`: **12px** — Default cards, modal dialogs, flyout sheets.
* `rounded-xl`: **16px** — Large hero preview panels, feature highlight containers.
* `rounded-full`: **9999px** — User avatars, status pills, icon buttons.

### 6.2 Elevation & Shadows
* **Subtle (`shadow-sm`)**: Light elements and inputs.  
  `0 1px 2px 0 rgb(0 0 0 / 0.05)`
* **Medium (`shadow-md`)**: Hovered cards and dropdown popovers.  
  `0 4px 6px -1px rgb(0 0 0 / 0.1), 0 2px 4px -2px rgb(0 0 0 / 0.1)`
* **Large (`shadow-xl`)**: Modals and slide-in sheets.  
  `0 20px 25px -5px rgb(0 0 0 / 0.1), 0 8px 10px -6px rgb(0 0 0 / 0.1)`
* **Dark Mode Glow**: Subtle border reflection instead of heavy drop shadows:  
  `border border-zinc-800 hover:border-zinc-700 hover:shadow-[0_0_25px_-5px_rgba(99,102,241,0.15)]`

---

## 7. Responsive Breakpoints

The layout uses mobile-first responsive design matching Tailwind CSS standards:

```text
┌──────────────┬─────────────┬────────────────────────────────────────────────────────┐
│ Breakpoint   │ Min Width   │ Primary Target Device                                  │
├──────────────┼─────────────┼────────────────────────────────────────────────────────┤
│ sm           │ 640px       │ Large smartphones / landscape phones                   │
│ md           │ 768px       │ Tablets / iPad portrait                                │
│ lg           │ 1024px      │ Laptops / iPad landscape (Desktop Nav triggers here)   │
│ xl           │ 1280px      │ Desktop monitors (Standard content container max-w)    │
│ 2xl          │ 1536px      │ Wide screens & workstations                            │
└──────────────┴─────────────┴────────────────────────────────────────────────────────┘
```

* **Max Content Width**: `max-w-7xl` (1280px) centered with `mx-auto px-4 sm:px-6 lg:px-8`.

---

## 8. Component Patterns & Code Examples

### 8.1 Buttons
Buttons provide clear visual feedback across all interaction states (default, hover, active, focus, disabled).

```tsx
import * as React from "react";
import { cva, type VariantProps } from "class-variance-authority";
import { cn } from "@/lib/utils";

const buttonVariants = cva(
  "inline-flex items-center justify-center whitespace-nowrap rounded-md text-sm font-medium transition-colors focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-indigo-500 focus-visible:ring-offset-2 disabled:pointer-events-none disabled:opacity-50 ring-offset-background",
  {
    variants: {
      variant: {
        primary: "bg-indigo-600 text-white hover:bg-indigo-500 shadow-sm",
        secondary: "bg-zinc-800 text-zinc-100 hover:bg-zinc-700 border border-zinc-700/60",
        outline: "border border-zinc-700 bg-transparent text-zinc-200 hover:bg-zinc-800/60 hover:text-white",
        ghost: "hover:bg-zinc-800 hover:text-zinc-100 text-zinc-400",
        destructive: "bg-red-600 text-white hover:bg-red-500 shadow-sm",
      },
      size: {
        sm: "h-8 px-3 text-xs rounded-md",
        default: "h-10 px-4 py-2",
        lg: "h-12 px-6 text-base rounded-lg",
        icon: "h-10 w-10",
      },
    },
    defaultVariants: {
      variant: "primary",
      size: "default",
    },
  }
);
```

### 8.2 Project Card Component Pattern
Standard card for displaying open-source repositories with stars, language badge, and direct links:

```tsx
import { Star, GitFork, ExternalLink } from "lucide-react";
import Link from "next/link";

interface ProjectCardProps {
  name: string;
  description: string;
  stars: number;
  forks: number;
  language: string;
  repoUrl: string;
}

export function ProjectCard({ name, description, stars, forks, language, repoUrl }: ProjectCardProps) {
  return (
    <div className="group relative flex flex-col justify-between rounded-xl border border-zinc-800 bg-zinc-900/50 p-6 backdrop-blur-sm transition-all duration-200 hover:border-zinc-700 hover:bg-zinc-900/80 hover:shadow-lg hover:shadow-indigo-500/5">
      <div>
        <div className="flex items-center justify-between gap-2">
          <h3 className="font-semibold text-lg text-zinc-100 group-hover:text-indigo-400 transition-colors">
            {name}
          </h3>
          <a
            href={repoUrl}
            target="_blank"
            rel="noreferrer"
            aria-label={`Open ${name} repository on GitHub`}
            className="text-zinc-500 hover:text-zinc-300 transition-colors"
          >
            <ExternalLink className="h-4 w-4" />
          </a>
        </div>
        <p className="mt-2 text-sm text-zinc-400 line-clamp-2 leading-relaxed">
          {description}
        </p>
      </div>

      <div className="mt-6 flex items-center justify-between text-xs text-zinc-500 border-t border-zinc-800/80 pt-4">
        <span className="flex items-center gap-1.5 font-medium text-zinc-300">
          <span className="h-2 w-2 rounded-full bg-indigo-500 inline-block" />
          {language}
        </span>
        <div className="flex items-center gap-4">
          <span className="flex items-center gap-1 hover:text-zinc-300 transition-colors">
            <Star className="h-3.5 w-3.5" /> {stars}
          </span>
          <span className="flex items-center gap-1 hover:text-zinc-300 transition-colors">
            <GitFork className="h-3.5 w-3.5" /> {forks}
          </span>
        </div>
      </div>
    </div>
  );
}
```

### 8.3 Event Card Component Pattern
Displays upcoming workshops, speakers, dates, and RSVP status:

```tsx
import { Calendar, Clock, MapPin } from "lucide-react";
import { Button } from "@/components/ui/button";

interface EventCardProps {
  title: string;
  date: string;
  time: string;
  location: string;
  status: "upcoming" | "completed";
  onRsvpClick: () => void;
}

export function EventCard({ title, date, time, location, status, onRsvpClick }: EventCardProps) {
  const isUpcoming = status === "upcoming";

  return (
    <div className="rounded-xl border border-zinc-800 bg-zinc-900/70 p-6 flex flex-col justify-between">
      <div>
        <div className="flex items-center justify-between">
          <span
            className={`inline-flex items-center rounded-full px-2.5 py-0.5 text-xs font-medium ${
              isUpcoming
                ? "bg-emerald-500/10 text-emerald-400 border border-emerald-500/20"
                : "bg-zinc-800 text-zinc-400"
            }`}
          >
            {isUpcoming ? "Upcoming Workshop" : "Completed"}
          </span>
        </div>
        <h4 className="mt-3 text-xl font-semibold text-zinc-100">{title}</h4>
        
        <div className="mt-4 space-y-2 text-sm text-zinc-400">
          <div className="flex items-center gap-2">
            <Calendar className="h-4 w-4 text-zinc-500" />
            <span>{date}</span>
          </div>
          <div className="flex items-center gap-2">
            <Clock className="h-4 w-4 text-zinc-500" />
            <span>{time}</span>
          </div>
          <div className="flex items-center gap-2">
            <MapPin className="h-4 w-4 text-zinc-500" />
            <span>{location}</span>
          </div>
        </div>
      </div>

      <div className="mt-6">
        {isUpcoming ? (
          <Button onClick={onRsvpClick} className="w-full bg-indigo-600 hover:bg-indigo-500">
            RSVP for Workshop
          </Button>
        ) : (
          <Button variant="outline" className="w-full" disabled>
            Event Concluded
          </Button>
        )}
      </div>
    </div>
  );
}
```

### 8.4 Glassmorphism Header & Mobile Navigation
Sticky desktop header with frosted glass effect and responsive mobile drawer:

```tsx
// Sticky Glassmorphism Header snippet
<header className="sticky top-0 z-50 w-full border-b border-zinc-800/80 bg-zinc-950/70 backdrop-blur-md supports-[backdrop-filter]:bg-zinc-950/60">
  <div className="max-w-7xl mx-auto flex h-16 items-center justify-between px-4 sm:px-6 lg:px-8">
    {/* Brand Logo & Navigation Links */}
  </div>
</header>
```

---

## 9. Animation Guidelines

Animations must be purposeful, fast, and unobtrusive. Micro-interactions communicate state changes; they must never delay user task completion.

### 9.1 Allowed Transitions & Timings

| Animation Type | Recommended Duration | Easing Function | Standard Purpose |
| :--- | :--- | :--- | :--- |
| **Fade In** | 150ms – 250ms | `cubic-bezier(0.16, 1, 0.3, 1)` | Modals, tooltips, tab content reveals |
| **Slide Up** | 200ms – 350ms | `cubic-bezier(0.16, 1, 0.3, 1)` | Dropdown menus, mobile sheet entry |
| **Scale Micro-bump** | 150ms | `ease-out` | Button clicks, checkbox toggles |
| **Skeleton Shimmer** | 1.5s infinite | `linear` | Content loading place-holders |
| **Hover Elevation** | 150ms – 200ms | `ease-out` | Card border brightening, icon hover |

### 9.2 Prohibited Patterns
* **No Parallax Scrolling**: Degrades framerates and causes vestibular discomfort.
* **No Auto-playing Carousels**: Violates cognitive accessibility and disrupts keyboard navigation.
* **No Heavy Particle Canvases**: Drains mobile battery and consumes thread execution time.
* **No Animations > 500ms**: Makes the user interface feel sluggish.
* **No Interactions Blocked by Animation**: Inputs and buttons must be immediately clickable without waiting for an entry animation to finish.

### 9.3 Prefers-Reduced-Motion Compliance
Every custom animation must respect system accessibility settings. Tailwind CSS utility `motion-reduce:` or CSS media queries must be utilized:

```css
@media (prefers-reduced-motion: reduce) {
  *, ::before, ::after {
    animation-duration: 0.01ms !important;
    animation-iteration-count: 1 !important;
    transition-duration: 0.01ms !important;
    scroll-behavior: auto !important;
  }
}
```

---

## 10. Iconography

* **Library**: `lucide-react`
* **Default Dimensions**: Standard UI elements use `h-5 w-5` (20px) or `h-4 w-4` (16px) for inline text badges.
* **Stroke Width**: `1.75px` or `2px` uniformly across all views.
* **Accessibility**: Non-text interactive icons must always provide an `aria-label` or wrapping button title. Decorative icons accompanying text must have `aria-hidden="true"`.

---

## 11. Image Guidelines

* **Format**: All static photos, avatars, and workshop banners must be encoded in **WebP** or **AVIF** format.
* **Next.js `<Image />` Component**:
  * Always provide explicit `width` and `height` (or `fill` with a relative parent container) to reserve layout space and achieve zero CLS.
  * Define appropriate responsive `sizes`:
    ```tsx
    <Image
      src={event.bannerUrl}
      alt={`Promotional banner for ${event.title}`}
      fill
      sizes="(max-width: 768px) 100vw, (max-width: 1200px) 50vw, 33vw"
      className="object-cover rounded-t-xl"
      priority={isFirstCard}
    />
    ```
* **Alt Text Requirement**: Meaningful, descriptive alt text is strictly mandatory. Never use generic labels like `"image"`, `"banner"`, or `"photo"`.

---

## 12. Accessibility (a11y) Checklist

Before merging any UI component or template, verify compliance against the following standards:

- [ ] **Contrast Ratio**: All body text achieves a minimum contrast ratio of **4.5:1** against its background (WCAG AA). Large text (>=24px) achieves at least **3:1**.
- [ ] **Visible Focus Rings**: Interactive elements feature a visible ring on keyboard focus using `focus-visible:ring-2 focus-visible:ring-indigo-500 focus-visible:ring-offset-2`. Focus rings must never be globally hidden with `outline: none`.
- [ ] **Keyboard Navigability**: All interactive controls (buttons, links, tab lists, modal dialogs) can be navigated and activated using `Tab`, `Shift+Tab`, `Enter`, `Space`, and `Escape`.
- [ ] **Modal Focus Trapping**: Dialogs and mobile slide-outs trap focus inside the container until dismissed via `Escape` or the close trigger.
- [ ] **Semantic HTML**: Proper use of `<header>`, `<nav>`, `<main>`, `<section>`, `<article>`, `<aside>`, and `<footer>`. Headings (`<h1>` through `<h6>`) follow strict sequential order without skipping levels.
- [ ] **Form Labels**: Every input, select, and textarea is explicitly bound to a `<label>` via `htmlFor` and `id`.
- [ ] **Screen Reader Verification**: Verify interactive state notifications with `aria-live="polite"` for dynamic content updates (e.g., search filter result counts, RSVP submission success).
