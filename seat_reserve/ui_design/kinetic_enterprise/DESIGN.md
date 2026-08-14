---
name: Kinetic Enterprise
colors:
  surface: '#f8f9ff'
  surface-dim: '#cbdbf5'
  surface-bright: '#f8f9ff'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#eff4ff'
  surface-container: '#e5eeff'
  surface-container-high: '#dce9ff'
  surface-container-highest: '#d3e4fe'
  on-surface: '#0b1c30'
  on-surface-variant: '#45464d'
  inverse-surface: '#213145'
  inverse-on-surface: '#eaf1ff'
  outline: '#76777d'
  outline-variant: '#c6c6cd'
  surface-tint: '#565e74'
  primary: '#000000'
  on-primary: '#ffffff'
  primary-container: '#131b2e'
  on-primary-container: '#7c839b'
  inverse-primary: '#bec6e0'
  secondary: '#006c49'
  on-secondary: '#ffffff'
  secondary-container: '#6cf8bb'
  on-secondary-container: '#00714d'
  tertiary: '#000000'
  on-tertiary: '#ffffff'
  tertiary-container: '#001a42'
  on-tertiary-container: '#3980f4'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#dae2fd'
  primary-fixed-dim: '#bec6e0'
  on-primary-fixed: '#131b2e'
  on-primary-fixed-variant: '#3f465c'
  secondary-fixed: '#6ffbbe'
  secondary-fixed-dim: '#4edea3'
  on-secondary-fixed: '#002113'
  on-secondary-fixed-variant: '#005236'
  tertiary-fixed: '#d8e2ff'
  tertiary-fixed-dim: '#adc6ff'
  on-tertiary-fixed: '#001a42'
  on-tertiary-fixed-variant: '#004395'
  background: '#f8f9ff'
  on-background: '#0b1c30'
  surface-variant: '#d3e4fe'
typography:
  display:
    fontFamily: Hanken Grotesk
    fontSize: 32px
    fontWeight: '700'
    lineHeight: 40px
    letterSpacing: -0.02em
  headline-lg:
    fontFamily: Hanken Grotesk
    fontSize: 24px
    fontWeight: '600'
    lineHeight: 32px
  headline-md:
    fontFamily: Hanken Grotesk
    fontSize: 20px
    fontWeight: '600'
    lineHeight: 28px
  body-lg:
    fontFamily: Inter
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
  body-md:
    fontFamily: Inter
    fontSize: 14px
    fontWeight: '400'
    lineHeight: 20px
  body-sm:
    fontFamily: Inter
    fontSize: 12px
    fontWeight: '400'
    lineHeight: 16px
  label-caps:
    fontFamily: JetBrains Mono
    fontSize: 11px
    fontWeight: '500'
    lineHeight: 16px
    letterSpacing: 0.05em
  button:
    fontFamily: Inter
    fontSize: 14px
    fontWeight: '600'
    lineHeight: 20px
rounded:
  sm: 0.125rem
  DEFAULT: 0.25rem
  md: 0.375rem
  lg: 0.5rem
  xl: 0.75rem
  full: 9999px
spacing:
  base: 4px
  xs: 4px
  sm: 8px
  md: 16px
  lg: 24px
  xl: 32px
  margin-mobile: 16px
  gutter-mobile: 12px
---

## Brand & Style

The design system is engineered for high-performance enterprise environments, specifically tailored for seat management and workspace logistics. The brand personality is **precise, authoritative, and frictionless**. It aims to evoke a sense of organized efficiency, reducing the cognitive load of administrative tasks through a structured visual hierarchy.

The design style is **Corporate Modern with a Focus on Utility**. It prioritizes clarity over decoration, utilizing a balanced mix of subtle tonal layering and crisp, functional accents. The aesthetic is "SaaS-native"—relying on generous whitespace and a systematic approach to density to ensure the interface remains legible even when displaying complex data sets or floor plans.

## Colors

The palette is anchored by **Slate 900 (#0F172A)**, a deep, professional blue-black used for primary text and core structural elements to establish authority. The primary action color is an **Emerald Green (#10B981)**, strategically employed to signal "Available," "Approved," or "Success," providing a positive psychological reinforcement for productivity.

**Slate 500 (#64748B)** serves as the neutral foundation for borders, secondary text, and inactive states. For highlights and information density, **Blue 500 (#3B82F6)** is used to denote interactive links or "In Progress" statuses. The background is kept to a clean, off-white to maintain high contrast and minimize eye strain during extended professional use.

## Typography

This design system utilizes a tri-font strategy to maximize legibility and information hierarchy. **Hanken Grotesk** is used for headlines, providing a modern, sharp edge that feels contemporary and professional. **Inter** is the workhorse for all body copy and UI elements, chosen for its exceptional readability on mobile displays and neutral tone.

For technical data, seat numbers, or status labels, **JetBrains Mono** is introduced. This monospaced font ensures that alphanumeric codes are easily distinguishable, reinforcing the "productivity tool" aesthetic. Use all-caps with the `label-caps` style for small metadata tags to differentiate them from actionable body text.

## Layout & Spacing

The layout follows a strict **4px baseline grid** to ensure mathematical consistency across all components. For mobile screens, use a **4-column fluid grid** with a 16px outer margin and 12px gutters.

The spacing rhythm is intentional: use `md` (16px) for standard grouping and `lg` (24px) to separate distinct content sections. Vertical stacks in lists should utilize `sm` (8px) padding between items to maintain a high information density without feeling cramped. All interactive targets must maintain a minimum height of 44px to comply with accessibility standards.

## Elevation & Depth

Hierarchy in this design system is achieved through **Tonal Layering** and **Subtle Outlines** rather than heavy shadows. 

1.  **Floor (Level 0):** Background surfaces use the default light gray/white.
2.  **Raised (Level 1):** Cards and container elements use a 1px solid border (#E2E8F0) with no shadow. This creates a "flat-but-organized" feel.
3.  **Active (Level 2):** When an element is selected (like a reserved seat), it gains a subtle 4px soft shadow with a 10% opacity of the primary color to indicate focus.

Avoid backdrop blurs; keep surfaces opaque to maintain the "solid" and "trustworthy" enterprise feel.

## Shapes

The shape language is **Soft (0.25rem / 4px)**. This slight rounding takes the edge off the brutalist "corporate" feel while remaining more professional and disciplined than "bubbly" consumer apps. 

Use the standard `rounded` (4px) for input fields, buttons, and small cards. Larger containers like modal sheets may use `rounded-lg` (8px) for a more defined containerization. Status indicators (dots) and avatar containers should remain circular (full rounded) to contrast against the predominantly rectangular UI.

## Components

-   **Buttons:** Primary buttons use a solid Slate 900 background with white text. Success actions (e.g., "Confirm Booking") use the Emerald Green. Secondary buttons are outlined with a 1px border.
-   **Input Fields:** Use a 1px border (#CBD5E1). On focus, the border shifts to Blue 500 with a 2px outer "glow" (0.1 opacity). Labels should always be visible above the input.
-   **Status Chips:** Small, pill-shaped containers. Use a light tinted background (10% opacity of the status color) with high-contrast text (e.g., Light Green background with Dark Green text).
-   **Seat Map Elements:** Seats are represented by squares with 4px corner radii. Use color coding: Slate 200 (Empty), Emerald 500 (Available), and Slate 900 (Occupied).
-   **Lists:** Use "Divided Lists" where items are separated by a 1px line. Each item should have a chevron icon if it leads to a detail view.
-   **Data Tables/Reports:** Use JetBrains Mono for all numeric values. Header rows should be Slate 50 background with `label-caps` typography.