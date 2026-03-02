import SwiftUI

// MARK: - Palette (mirrors BodygraphView synthwave colors)

private extension Color {
    static let pCyan    = Color(red: 0.298, green: 0.788, blue: 0.941) // personality
    static let pMagenta = Color(red: 1.000, green: 0.220, blue: 0.702) // design
    static let pBg      = Color(red: 0.027, green: 0.027, blue: 0.102) // #07071A
}

// MARK: - Planet Column

struct PlanetColumnView: View {
    let planets: [String: HDPlanetData]
    let isDesign: Bool
    let scale: CGFloat  // driven from ContentView GeometryReader (1.0 ≈ 700 pt tall window)

    private static let order = [
        "sun", "earth", "moon", "north_node", "south_node",
        "mercury", "venus", "mars", "jupiter", "saturn",
        "uranus", "neptune", "pluto"
    ]

    private static let symbols: [String: String] = [
        "sun": "☉", "earth": "⊕", "moon": "☽",
        "north_node": "☊", "south_node": "☋",
        "mercury": "☿", "venus": "♀", "mars": "♂",
        "jupiter": "♃", "saturn": "♄", "uranus": "♅",
        "neptune": "♆", "pluto": "♇"
    ]

    // Scaled metrics
    private var fontSize:    CGFloat { max(11,   18 * scale) }
    private var headerSize:  CGFloat { max(7,    10 * scale) }
    private var dignitySize: CGFloat { max(8,    12 * scale) }
    private var rowHeight:   CGFloat { max(20,   30 * scale) }
    // Column width derived from row content so nothing ever clips
    private var colWidth: CGFloat {
        let glyphW   = max(18.0, fontSize * 1.3)
        let gateW    = max(30.0, fontSize * 2.5)
        let dignityW = max(14.0, dignitySize * 1.5)
        let gap      = max(3.0,  fontSize * 0.22)
        return glyphW + gap + gateW + gap + dignityW + 16  // 16 = 8pt hPad × 2
    }

    private var color: Color { isDesign ? .pMagenta : .pCyan }
    private var title: String { isDesign ? "DESIGN" : "PERSONALITY" }

    var body: some View {
        VStack(spacing: 0) {

            // ── Header ──────────────────────────────────────────────────────
            Text(title)
                .font(.system(size: headerSize, weight: .semibold))
                .tracking(1.5)
                .foregroundStyle(color.opacity(0.80))
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.horizontal, 10)
                .padding(.top, 12)
                .padding(.bottom, 5)

            Rectangle()
                .fill(color.opacity(0.25))
                .frame(height: 1)
                .padding(.horizontal, 6)

            // ── Planet rows (flush to header, space below) ──────────────────
            VStack(spacing: 0) {
                ForEach(Self.order, id: \.self) { key in
                    if let data = planets[key], let symbol = Self.symbols[key] {
                        PlanetRow(
                            symbol: symbol,
                            data: data,
                            isDesign: isDesign,
                            color: color,
                            fontSize: fontSize,
                            dignitySize: dignitySize,
                            rowHeight: rowHeight
                        )
                    }
                }
            }
            .padding(.top, max(4, 6 * scale))
            .padding(.bottom, max(6, 10 * scale))
        }
        .frame(minWidth: colWidth, maxWidth: colWidth)
        .background(Color.pBg)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

// MARK: - Planet Row

private struct PlanetRow: View {
    let symbol:      String
    let data:        HDPlanetData
    let isDesign:    Bool
    let color:       Color
    let fontSize:    CGFloat
    let dignitySize: CGFloat
    let rowHeight:   CGFloat

    private var gateLine: String { "\(data.gate).\(data.line)" }

    // ☉ renders visually smaller than all other astrological glyphs in SF Pro
    private var symbolFontSize: CGFloat {
        symbol == "☉" ? fontSize * 1.35 : fontSize
    }

    private var dignityGlyph: String? {
        switch data.dignity {
        case "exalted":   return "▲"
        case "detriment": return "▽"
        default:          return nil
        }
    }

    var body: some View {
        let sfPro       = Font.system(size: fontSize,    weight: .medium)
        let dignityFont = Font.system(size: dignitySize, weight: .bold)
        // Fixed column widths — same for every row so values stack into a grid
        let glyphW   = max(18.0, fontSize * 1.3)
        let gateW    = max(30.0, fontSize * 2.5)
        let dignityW = max(14.0, dignitySize * 1.5)
        let gap      = max(3.0,  fontSize * 0.22)

        HStack(spacing: gap) {
            if isDesign {
                // Col 1 — glyph, centered
                Text(symbol)
                    .font(.system(size: symbolFontSize, weight: .medium))
                    .frame(width: glyphW, alignment: .center)
                    .foregroundStyle(Color.white.opacity(0.45))
                // Col 2 — gate activation, centered, tabular digits
                Text(gateLine)
                    .monospacedDigit()
                    .frame(width: gateW, alignment: .center)
                    .foregroundStyle(color)
                // Col 3 — dignity, centered (empty slot keeps column width when absent)
                Group {
                    if let g = dignityGlyph {
                        Text(g).font(dignityFont)
                            .foregroundStyle(g == "▲" ? color : color.opacity(0.60))
                    } else {
                        Color.clear
                    }
                }
                .frame(width: dignityW, alignment: .center)
            } else {
                // Col 1 — dignity, centered (mirrored)
                Group {
                    if let g = dignityGlyph {
                        Text(g).font(dignityFont)
                            .foregroundStyle(g == "▲" ? color : color.opacity(0.60))
                    } else {
                        Color.clear
                    }
                }
                .frame(width: dignityW, alignment: .center)
                // Col 2 — gate activation, centered, tabular digits
                Text(gateLine)
                    .monospacedDigit()
                    .frame(width: gateW, alignment: .center)
                    .foregroundStyle(color)
                // Col 3 — glyph, centered
                Text(symbol)
                    .font(.system(size: symbolFontSize, weight: .medium))
                    .frame(width: glyphW, alignment: .center)
                    .foregroundStyle(Color.white.opacity(0.45))
            }
        }
        .font(sfPro)
        .frame(height: rowHeight)
        .padding(.horizontal, 8)
    }
}
