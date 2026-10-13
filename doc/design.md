# Chessing — Design Specification

> Version 1.0 · 2026-10-13 · Written contract between visual design and Flutter implementation.

---

## 1. Design Principles

1. **Tactile & Responsive:** Chess is a physical, deliberate game. Moves must feature crisp animations (150–200ms), immediate piece responsiveness, and subtle haptic feedback on captures and checks.
2. **Visual Clarity Over Clutter:** The chessboard is the primary hero. Secondary controls (clocks, move history, engine eval) must frame the board without distracting from tactical calculation.
3. **Curated Board Themes:** Rather than arbitrary color pickers, the app provides 4 carefully harmonized board palettes tailored for different environments (daylight study, wooden tradition, nocturnal OLED gaming, and ultra-flat minimalism).
4. **Marked & Helpful AI:** AI commentary and coaching tips are styled distinctly with subtle purple/indigo tertiary tones, spark icons (`Icons.auto_awesome`), and clear markdown formatting.
5. **Adaptive Dark/Light Contrast:** Fully supports system Dark and Light modes with seamless surface transitions.

---

## 2. Color Palette & Board Themes

### Core Theme Tokens (`AppTheme`)

| Role | Light Value | Dark Value | Purpose |
|---|---|---|---|
| **Primary** | `#8B5E3C` (Warm Wood) | `#B58863` (Light Wood) | Main action buttons, active navigation items |
| **Secondary** | `#739552` (Olive Green) | `#ECECD7` (Soft Cream) | Selection rings, success states, legal move dots |
| **Surface** | `#F9F7F4` (Off-white) | `#1E1E1E` (Dark Charcoal) | App background |
| **Card / Surface Container** | `#FFFFFF` | `#2C2C2C` | Elevating panels, move log cards, dialogs |
| **Error / Threat** | `#EB5757` | `#EF5350` | In-check king square, blunder tags |

---

### Chess Board Themes (`ChessBoardTheme`)

Defined in [`lib/app/theme.dart`](file:///d:/M/flutter/chessing/lib/app/theme.dart):

#### 1. Classic (Standard tournament vinyl)
- **Light Square:** `#F0D9B5` (Light) / `#ECECD7` (Dark)
- **Dark Square:** `#B58863` (Light) / `#739552` (Dark)
- **Selection Highlight:** `Color(0x80BAC141)`
- **Check Accent:** `#EB5757`

#### 2. Wood (Handcrafted mahogany & maple)
- **Light Square:** `#DEB887` (Light) / `#C8A87A` (Dark)
- **Dark Square:** `#8B4513` (Light) / `#6B3410` (Dark)
- **Selection Highlight:** `Color(0x80FFD700)`
- **Check Accent:** `#DC143C`

#### 3. Neon (Cyberpunk OLED contrast)
- **Light Square:** `#1A1A2E` (Light) / `#0D0D1A` (Dark)
- **Dark Square:** `#16213E` (Light) / `#101025` (Dark)
- **Selection Highlight:** `Color(0xA000FFCC)` (Electric Cyan)
- **Legal Move Dots:** `Color(0xCC00FFCC)`
- **Check Accent:** `#FFFF0066` (Neon Magenta)

#### 4. Minimal (Ultra-clean modern grayscale)
- **Light Square:** `#F5F5F5` (Light) / `#424242` (Dark)
- **Dark Square:** `#9E9E9E` (Light) / `#212121` (Dark)
- **Selection Highlight:** `Color(0x803F51B5)` / `Color(0x807C4DFF)`
- **Check Accent:** `#F44336`

---

## 3. Typography & Notation

- **Primary Font:** System / Inter for UI typography and navigation labels.
- **Move Notation Font:** Monospaced tabular figures (`RobotoMono` or system monospace) for SAN/UCI move strings (e.g. `1. e4 e5 2. Nf3 Nc6`) to ensure fixed column widths and clean alignment in move lists.
- **Clock Display:** Large tabular numbers (28–32sp, SemiBold) ensuring countdown digits do not cause horizontal layout shifts.

---

## 4. Key UI Components & Interactions

1. **The Board Widget:**
   - 1:1 Aspect ratio, bounded to screen width with 16dp horizontal padding.
   - Rank and file labels placed along square borders or subtly embedded in corner squares.
   - Subtle dot indicators for legal move targets; radial pulse indicator when king is in check.
2. **The Chess Clock:**
   - Dual player clock cards with high-contrast active timer state.
   - Warning state (red pulse animation) when remaining time falls below 10 seconds.
3. **The Evaluation Graph (`fl_chart`):**
   - Centipawn evaluation curve ranging from -1000 to +1000 with a central zero equilibrium line.
   - Scrubber line allowing the player to tap or drag along the curve to scrub the board to that exact historical move.
4. **Move Quality Tags:**
   - **Brilliant (!!):** Cyan badge with sparkles (`#00E5FF`).
   - **Best / Great (!):** Bright green badge (`#00C853`).
   - **Inaccuracy (?!):** Yellow badge (`#FFD600`).
   - **Mistake (?):** Orange badge (`#FF9100`).
   - **Blunder (??):** Bright red badge (`#D50000`).
