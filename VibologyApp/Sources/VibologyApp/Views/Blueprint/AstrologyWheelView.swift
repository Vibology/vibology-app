import SwiftUI

// MARK: - Palette

private extension Color {
    static let wBg      = Color(red: 0.027, green: 0.027, blue: 0.102)
    static let wBgMid   = Color(red: 0.051, green: 0.043, blue: 0.149)
    static let wCyan    = Color(red: 0.298, green: 0.788, blue: 0.941)
    static let wMagenta = Color(red: 1.000, green: 0.220, blue: 0.702)
    // Element fill tints
    static let wFire    = Color(red: 1.000, green: 0.220, blue: 0.702).opacity(0.16)
    static let wEarth   = Color(red: 0.957, green: 0.635, blue: 0.165).opacity(0.16)
    static let wAir     = Color(red: 0.298, green: 0.788, blue: 0.941).opacity(0.16)
    static let wWater   = Color(red: 0.267, green: 0.533, blue: 1.000).opacity(0.16)
}

// MARK: - Static Lookup Tables

private let zodiacData: [(abbrev: String, glyph: String, startLon: Double)] = [
    ("Ari", "♈",   0), ("Tau", "♉",  30), ("Gem", "♊",  60),
    ("Can", "♋",  90), ("Leo", "♌", 120), ("Vir", "♍", 150),
    ("Lib", "♎", 180), ("Sco", "♏", 210), ("Sag", "♐", 240),
    ("Cap", "♑", 270), ("Aqu", "♒", 300), ("Pis", "♓", 330),
]

// Aries=Fire, Taurus=Earth, Gemini=Air, Cancer=Water, repeating
private let elementColors: [Color] = [.wFire, .wEarth, .wAir, .wWater]

private let planetOrder = [
    "sun", "moon", "mercury", "venus", "mars",
    "jupiter", "saturn", "uranus", "neptune", "pluto",
    "mean_north_lunar_node", "chiron",
]

private let planetGlyphs: [String: String] = [
    "sun": "☉", "moon": "☽", "mercury": "☿", "venus": "♀",
    "mars": "♂", "jupiter": "♃", "saturn": "♄", "uranus": "♅",
    "neptune": "♆", "pluto": "♇",
    "mean_north_lunar_node": "☊", "mean_south_lunar_node": "☋",
    "chiron": "⚷",
]

private let majorAspectTypes: Set<String> = [
    "conjunction", "opposition", "trine", "square", "sextile", "quincunx",
]

// MARK: - AstrologyWheelView

struct AstrologyWheelView: View {
    let data: AstrologyData

    // DSC (7th house cusp) anchors angle 0 — ASC lands at π (left / 9 o'clock)
    private var dscLon: Double { data.houses["house_7"] ?? 180 }

    var body: some View {
        Canvas { ctx, size in
            let dim    = min(size.width, size.height)
            let R      = dim * 0.430                         // outer zodiac radius
            let c      = CGPoint(x: size.width / 2, y: size.height / 2)

            // Concentric ring radii
            let rOuter  = R                                  // outer zodiac edge
            let rZodiac = R * 0.820                          // inner zodiac / planet outer
            let rPlanet = R * 0.640                          // planet glyph ring
            let rInner  = R * 0.455                          // inner boundary (house/aspect)

            // ── 1. Zodiac ring slices (element fill) ─────────────────────────
            for (i, sign) in zodiacData.enumerated() {
                let l1 = sign.startLon
                let l2 = l1 + 30.0
                var path = Path()
                path.move(to: pt(l1, rOuter, c))
                for s in 1...24 { path.addLine(to: pt(l1 + Double(s) / 24.0 * 30, rOuter, c)) }
                for s in 1...24 { path.addLine(to: pt(l2 - Double(s) / 24.0 * 30, rZodiac, c)) }
                path.closeSubpath()
                ctx.fill(path, with: .color(elementColors[i % 4]))
            }

            // ── 2. Sign boundary radial lines ────────────────────────────────
            for sign in zodiacData {
                var p = Path()
                p.move(to: pt(sign.startLon, rZodiac, c))
                p.addLine(to: pt(sign.startLon, rOuter, c))
                ctx.stroke(p, with: .color(.white.opacity(0.22)), lineWidth: 0.5)
            }

            // ── 3. Ring circles (outer + zodiac inner) ────────────────────────
            ctx.stroke(circle(rOuter, c),  with: .color(.white.opacity(0.28)), lineWidth: 1.0)
            ctx.stroke(circle(rZodiac, c), with: .color(.white.opacity(0.20)), lineWidth: 0.5)

            // ── 4. Degree tick marks (every 5°, longer every 10°) ─────────────
            for deg in stride(from: 0.0, to: 360.0, by: 5.0) {
                guard Int(deg) % 30 != 0 else { continue }      // sign lines already drawn
                let major = Int(deg) % 10 == 0
                let rTick = rZodiac + (rOuter - rZodiac) * (major ? 0.28 : 0.14)
                var p = Path()
                p.move(to: pt(deg, rZodiac, c))
                p.addLine(to: pt(deg, rTick, c))
                ctx.stroke(p, with: .color(.white.opacity(0.14)), lineWidth: 0.5)
            }

            // ── 5. Sign glyphs (midpoint of each sign segment) ───────────────
            let rSignGlyph  = (rOuter + rZodiac) / 2
            let signFontSz  = max(9.0, dim * 0.040)
            for sign in zodiacData {
                let label = Text(sign.glyph)
                    .font(.system(size: signFontSz, weight: .medium))
                    .foregroundStyle(Color.white.opacity(0.65))
                ctx.draw(ctx.resolve(label), at: pt(sign.startLon + 15, rSignGlyph, c))
            }

            // ── 6. Inner boundary circle ──────────────────────────────────────
            ctx.stroke(circle(rInner, c), with: .color(.white.opacity(0.18)), lineWidth: 0.5)

            // ── 7. House lines ────────────────────────────────────────────────
            let axisIndices: Set<Int> = [0, 3, 6, 9]          // houses 1, 4, 7, 10
            for i in 0..<12 {
                guard let lon = data.houses["house_\(i + 1)"] else { continue }
                let isAxis  = axisIndices.contains(i)
                let rStart  = isAxis ? 0.0 : rInner
                let opacity = isAxis ? 0.55 : 0.22
                let lw: CGFloat = isAxis ? 1.0 : 0.5
                var p = Path()
                p.move(to: pt(lon, rStart, c))
                p.addLine(to: pt(lon, rZodiac, c))
                ctx.stroke(p, with: .color(.white.opacity(opacity)), lineWidth: lw)
            }

            // ── 8. House number labels ─────────────────────────────────────────
            let hNumFontSz = max(7.0, dim * 0.026)
            let rHouseNum  = rInner * 0.66
            for i in 0..<12 {
                let nextHouse = (i == 11) ? 1 : i + 2
                guard let lon1 = data.houses["house_\(i + 1)"],
                      let lon2 = data.houses["house_\(nextHouse)"] else { continue }
                let mid = midLon(lon1, lon2)
                let label = Text("\(i + 1)")
                    .font(.system(size: hNumFontSz, weight: .light))
                    .foregroundStyle(Color.white.opacity(0.30))
                ctx.draw(ctx.resolve(label), at: pt(mid, rHouseNum, c))
            }

            // ── 9. Axis labels (Asc / IC / Dsc / MC) ────────────────────────
            let axisLabelSz = max(8.0, dim * 0.032)
            let axisLabels: [(key: String, text: String)] = [
                ("house_1", "Asc"), ("house_4", "IC"),
                ("house_7", "Dsc"), ("house_10", "MC"),
            ]
            for al in axisLabels {
                guard let lon = data.houses[al.key] else { continue }
                let label = Text(al.text)
                    .font(.system(size: axisLabelSz, weight: .semibold))
                    .foregroundStyle(Color.white.opacity(0.72))
                ctx.draw(ctx.resolve(label), at: pt(lon, rOuter + max(4, dim * 0.020), c))
            }

            // ── 10. Aspect lines ──────────────────────────────────────────────
            //  Draw inside the inner circle; opacity fades as orb widens.
            let rAspect = rInner * 0.94
            for asp in data.aspects where majorAspectTypes.contains(asp.aspect) && asp.orb <= 8.0 {
                guard let p1lon = data.planets[asp.planet1.lowercased()]?.longitude,
                      let p2lon = data.planets[asp.planet2.lowercased()]?.longitude else { continue }
                let fade = max(0.08, 0.90 - asp.orb * 0.10)
                var path = Path()
                path.move(to: pt(p1lon, rAspect, c))
                path.addLine(to: pt(p2lon, rAspect, c))
                ctx.stroke(path,
                           with: .color(aspectColor(asp.aspect).opacity(fade)),
                           lineWidth: aspectLineWidth(asp.aspect))
            }

            // ── 11. Planet tick lines (true longitude → near inner ring) ──────
            for key in planetOrder {
                guard let planet = data.planets[key] else { continue }
                var p = Path()
                p.move(to: pt(planet.longitude, rZodiac, c))
                p.addLine(to: pt(planet.longitude, rPlanet + (rZodiac - rPlanet) * 0.10, c))
                ctx.stroke(p, with: .color(.white.opacity(0.14)), lineWidth: 0.5)
            }

            // ── 12. Planet glyphs ─────────────────────────────────────────────
            let pFontSz = max(11.0, dim * 0.042)
            let rFontSz = max(7.0,  dim * 0.025)
            for key in planetOrder {
                guard let planet = data.planets[key],
                      let glyph = planetGlyphs[key] else { continue }
                let glyphLabel = Text(glyph)
                    .font(.system(size: pFontSz, weight: .medium))
                    .foregroundStyle(Color.white.opacity(0.90))
                ctx.draw(ctx.resolve(glyphLabel), at: pt(planet.longitude, rPlanet, c))

                if planet.retrograde {
                    // Small "℞" just clockwise of the glyph
                    let retroPt = pt(planet.longitude - 3.5, rPlanet - max(6, dim * 0.022), c)
                    let retroLabel = Text("℞")
                        .font(.system(size: rFontSz, weight: .light))
                        .foregroundStyle(Color.white.opacity(0.50))
                    ctx.draw(ctx.resolve(retroLabel), at: retroPt)
                }
            }
        }
        .aspectRatio(1, contentMode: .fit)
        .background(
            LinearGradient(
                colors: [.wBg, .wBgMid],
                startPoint: .top, endPoint: .bottom
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    // MARK: - Geometry Helpers

    /// Screen point for ecliptic `longitude` on a circle of `radius` centred at `c`.
    /// DSC sits at angle 0 (right), ASC at π (left) — standard Western wheel orientation.
    private func pt(_ longitude: Double, _ radius: CGFloat, _ c: CGPoint) -> CGPoint {
        let a = (dscLon - longitude) * .pi / 180
        return CGPoint(x: c.x + radius * cos(a),
                       y: c.y + radius * sin(a))
    }

    /// Axis-aligned bounding rect for a circle centred at `c`.
    private func circle(_ r: CGFloat, _ c: CGPoint) -> Path {
        Path(ellipseIn: CGRect(x: c.x - r, y: c.y - r, width: r * 2, height: r * 2))
    }

    /// Midpoint ecliptic longitude between two house cusps, accounting for 0°/360° wrap.
    private func midLon(_ l1: Double, _ l2: Double) -> Double {
        var l2w = l2
        if l2w < l1 { l2w += 360 }
        let mid = (l1 + l2w) / 2
        return mid >= 360 ? mid - 360 : mid
    }

    // MARK: - Aspect Style

    private func aspectColor(_ type: String) -> Color {
        switch type {
        case "conjunction": return .white
        case "opposition":  return Color(red: 1.00, green: 0.36, blue: 0.30)
        case "trine":       return .wCyan
        case "square":      return .wMagenta
        case "sextile":     return Color(red: 0.298, green: 0.788, blue: 0.941).opacity(0.60)
        case "quincunx":    return Color.white.opacity(0.35)
        default:            return Color.white.opacity(0.20)
        }
    }

    private func aspectLineWidth(_ type: String) -> CGFloat {
        switch type {
        case "conjunction": return 1.1
        case "opposition":  return 0.9
        case "trine":       return 0.8
        case "square":      return 0.8
        case "sextile":     return 0.65
        default:            return 0.5
        }
    }
}
