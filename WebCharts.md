# Vibology Web Charts — Build Plan

## Goal

A beautiful, interactive chart renderer that:
- Lives on **vibology.org** (Ghost) as an embeddable page
- Feeds from the existing **Cartographer** Cloud Run API
- Shares the Synthwave/Glassmorphism visual language of the Mac app
- Produces both a **natal astrology wheel** and a **Human Design bodygraph**

---

## Architecture

```
vibology.org (Ghost page)
  └── HTML form (date, time, place)
       └── fetch() → Cartographer Cloud Run API (JSON)
            └── SVG/JS renderer → chart displayed in browser
```

Cartographer's sole job is returning clean JSON. All visual rendering happens client-side in the browser. This means:
- Charts are interactive (hover states, animations, tooltips)
- No server-side image generation or bottleneck
- The same JSON payload later feeds the SwiftUI Mac app

---

## Phase 1 — API Readiness

### 1.1 Add CORS to Cartographer

Ghost pages are served from `vibology.org`. The browser will reject cross-origin fetch calls to Cloud Run unless Cartographer explicitly allows it.

**File:** `Cartographer/src/cartographer/api.py`

Add FastAPI CORS middleware:

```python
from fastapi.middleware.cors import CORSMiddleware

app.add_middleware(
    CORSMiddleware,
    allow_origins=["https://vibology.org", "https://www.vibology.org"],
    allow_methods=["GET", "POST"],
    allow_headers=["Content-Type"],
)
```

Redeploy: `cd Cartographer && make deploy`

### 1.2 Verify Endpoint Contracts

Confirm the two endpoints the renderer will consume:

**Natal chart:** `GET /chart/natal?...` or `POST /chart/natal`
- Returns: planets (sign, degree, motion), houses (cusps, angles), aspects

**Bodygraph:** `GET /humandesign/calculate?birth_date=&birth_time=&birth_place=`
- Returns: type, profile, channels, personalityActivation, designActivation, variables

### 1.3 Add Geocoding Input Support

The HD endpoint currently accepts `birth_place` as a string (Nominatim geocodes it).
The natal endpoint may require explicit lat/lon — confirm or add geocoding parity.

---

## Phase 2 — Chart Renderer

Build as **vanilla SVG + JavaScript** (no framework dependency). Renders in any browser,
embeds cleanly in Ghost via Code Injection or a custom page template.

### 2.1 Human Design Bodygraph

The bodygraph is a fixed geometric layout — 9 centers, 36 channels, 64 gates.

**Center geometry** (all positions are fixed, not data-driven):

| Center | Shape | Notes |
|--------|-------|-------|
| Head | Triangle (point up) | Top of chart |
| Ajna | Triangle (point down) | Below Head |
| Throat | Rectangle | Center-top |
| G / Self | Diamond | Center |
| Heart / Ego | Triangle (small) | Right of G |
| Sacral | Rectangle | Center-bottom |
| Spleen | Triangle | Left of Sacral |
| Solar Plexus | Triangle | Right of Sacral |
| Root | Square | Bottom |

**Rendering logic:**
1. Draw all centers as outlines (undefined = white/translucent)
2. Fill defined centers with color (per center's traditional color)
3. Draw channel lines between connected centers
4. Highlight active channels (from `activeChannels` array)
5. Annotate gate positions on channel lines (gate number + line)
6. Mark defined gates with personality (black) vs design (red) coloring
7. Add planet glyphs along the left (personality) and right (design) columns

**Visual treatment:**
- Background: deep dark (`#0d0e1a` or similar)
- Undefined centers: translucent white with subtle border
- Defined centers: filled with neon-tinted color + glassmorphism blur
- Active channels: glowing stroke (Synthwave accent color per circuit type)
- Gate numbers: small, monospace, dimmed
- Planet glyphs: Unicode or SVG glyphs

**Circuit color coding (optional enhancement):**
- Integration channels: gold
- Tribal channels: orange/red
- Individual channels: green
- Collective-logic channels: yellow
- Collective-abstract channels: blue

### 2.2 Natal Astrology Wheel

A circular chart divided into 12 houses with planetary placements.

**Layers (center-out):**
1. Center point
2. House cusps — 12 divisions, with house numbers
3. Planet ring — glyphs placed at their ecliptic longitude
4. Sign ring — 12 zodiac glyphs, 30° each
5. Aspect lines — connecting planets across the center (color-coded by aspect type)
6. Outer degree ring — tick marks every 5°

**Rendering logic:**
1. Convert each planet's ecliptic longitude to SVG angle
2. Place glyph at that angle on the planet ring
3. Draw house cusp lines from center to sign ring boundary
4. For each aspect: draw a line between the two planet positions, color by type
5. Shade house quadrants subtly (angular/succedent/cadent distinction)

**Aspect colors:**
- Conjunction: white
- Trine: blue/teal
- Sextile: green
- Square: red/coral
- Opposition: orange
- Quincunx: purple (dimmed)

**Visual treatment:**
- Same dark background as bodygraph (cohesive set)
- Zodiac ring: gradient fill matching brand palette
- Planet glyphs: Unicode astrological symbols (☉ ☽ ♀ ♂ etc.)
- Retrograde planets: glyph + ℞ superscript, dimmed slightly
- Glassmorphism panel below chart showing planet-by-planet table

### 2.3 Shared JS Module Structure

```
web/
├── index.html              # Ghost-embeddable page (form + chart container)
├── charts.css              # Synthwave design tokens, animations
├── cartographer-client.js  # fetch() wrapper for Cartographer API
├── bodygraph.js            # Bodygraph SVG renderer
├── natal-wheel.js          # Natal wheel SVG renderer
└── glyphs.js               # Planet/sign Unicode or SVG glyph map
```

No build step required — plain ES modules, loadable via `<script type="module">`.

---

## Phase 3 — Ghost Integration

### 3.1 Create a Ghost Page

In Ghost admin:
1. Create a new **Page** (not a post): e.g., "Your Chart"
2. Set a custom URL: `/chart`
3. Inject the chart form HTML into the page body
4. Use **Settings → Code Injection → Site Footer** to load the JS modules

Or: use a **custom Ghost theme template** (`page-chart.hbs`) for full layout control.

### 3.2 Form Design

Minimal inputs:
- Date (date picker)
- Time (time input, with "unknown time" toggle that disables houses)
- Place (text input with typeahead, resolved to lat/lon via Cartographer's geocoding)
- Chart type selector: Natal / Bodygraph / Both

On submit: fetch from Cartographer → render SVG inline → show download/share options.

### 3.3 Shareable Output

Options for sharing/saving:
- **Download SVG**: `<a href="data:image/svg+xml,...">` link
- **Download PNG**: use `canvas.toBlob()` after drawing to an offscreen canvas
- **Permalink**: encode birth data in URL params so the page is bookmarkable

---

## Phase 4 — SwiftUI Port (Mac App)

Once the SVG geometry is validated in the browser, port the layout logic to **SwiftUI Canvas**.

- `Canvas { context, size in ... }` replaces SVG
- Same coordinate math, same center positions
- SwiftUI `Path` for center shapes and channel lines
- `Text` overlays for gate numbers and planet glyphs
- `withAnimation` for definition highlight transitions
- Native macOS share sheet for PDF export (via PDFKit)

The web version is the design prototype; the Mac version is the polished implementation.

---

## Design Tokens (Shared)

```
Background:       #0d0e1a
Surface:          rgba(255, 255, 255, 0.05)  ← glassmorphism panel
Border:           rgba(255, 255, 255, 0.12)
Text primary:     #e8f5ff                    ← Pearl
Accent cyan:      #9DD8F7
Accent lavender:  #B8A5E5
Personality:      #1a1a2e (dark, near-black) ← traditional HD black
Design:           #8b1a1a (dark red)         ← traditional HD red
Defined fill:     per-center color + 60% opacity + blur
Undefined fill:   rgba(255, 255, 255, 0.03)
Glow:             0 0 12px currentColor
Font:             monospace for gate numbers, system-ui for labels
```

---

## Open Questions

- **Natal endpoint shape**: does `/chart/natal` accept `birth_place` string or require lat/lon?
  If the latter, add Nominatim geocoding to the natal router (same as HD already does).
- **Time zone for natal**: Cartographer's HD endpoint derives timezone from place.
  Natal endpoint currently requires an explicit `timezone` string — unify the input UX.
- **Unknown birth time**: House cusps and Ascendant are meaningless without a time.
  The form should allow "time unknown" and render a wheel without houses in that case.
- **Mobile**: Ghost pages are responsive. The SVG charts need a `viewBox` and no fixed
  pixel dimensions so they scale on smaller screens.

---

## Deployment Order

1. Add CORS to Cartographer → redeploy
2. Build and test `bodygraph.js` locally (static HTML, hardcoded JSON fixture)
3. Build and test `natal-wheel.js` locally
4. Wire up `cartographer-client.js` + form
5. Embed in Ghost page, test end-to-end
6. Port geometry to SwiftUI Canvas
