import SwiftUI
import AppKit

// MARK: - Wheel Color Palette

private extension Color {
    // Deep space — identical to BodygraphView background
    static let wheelBg       = Color(red: 0.027, green: 0.027, blue: 0.102) // #07071A
    // Neon accents — same as BodygraphView channel colors
    static let neonCyan      = Color(red: 0.298, green: 0.788, blue: 0.941) // #4CC9F0 personality
    static let neonMagenta   = Color(red: 1.000, green: 0.220, blue: 0.702) // #FF38B3 design
    // Brand gradient tones
    static let brandCyan     = Color(red: 0.616, green: 0.847, blue: 0.969) // #9DD8F7
    static let brandLavender = Color(red: 0.722, green: 0.647, blue: 0.898) // #B8A5E5
    static let brandPearl    = Color(red: 0.910, green: 0.961, blue: 1.000) // #E8F5FF
    // Sector fills — one hue per element, drawn from the brand palette
    static let signFire  = Color(red: 1.000, green: 0.220, blue: 0.702).opacity(0.18) // neonMagenta — Fire
    static let signEarth = Color(red: 0.961, green: 0.651, blue: 0.137).opacity(0.15) // warm amber  — Earth
    static let signAir   = Color(red: 0.298, green: 0.788, blue: 0.941).opacity(0.18) // neonCyan    — Air
    static let signWater = Color(red: 0.722, green: 0.647, blue: 0.898).opacity(0.20) // brandLavender — Water
}

private let elementFill: [String: Color] = [
    "Ari": .signFire,  "Leo": .signFire,  "Sag": .signFire,
    "Tau": .signEarth, "Vir": .signEarth, "Cap": .signEarth,
    "Gem": .signAir,   "Lib": .signAir,   "Aqu": .signAir,
    "Can": .signWater, "Sco": .signWater, "Pis": .signWater,
]

// MARK: - Static lookup tables (Swift-side — no server involvement)

private let signNames = ["Ari","Tau","Gem","Can","Leo","Vir",
                         "Lib","Sco","Sag","Cap","Aqu","Pis"]

// Full SVG filenames in the same order as signNames (0° Aries → 330° Pisces)
private let signFileNames = [
    "Aries","Taurus","Gemini","Cancer","Leo","Virgo",
    "Libra","Scorpio","Sagittarius","Capricorn","Aquarius","Pisces",
]

// Zodiac SVGs loaded once, tinted white for visibility on the dark wheel.
// lockFocus/unlockFocus forces immediate rasterization into a bitmap rep —
// lazy drawing handlers (NSImage(size:flipped:drawingHandler:)) are unreliable
// in SwiftUI Canvas because ctx.resolve() may not provide an NSGraphicsContext.
private let zodiacImages: [Image?] = signFileNames.map { name in
    func locate() -> URL? {
        if let url = Bundle.main.url(forResource: name, withExtension: "svg") {
            return url
        }
        for base in [Bundle.main.resourceURL, Bundle.main.bundleURL].compactMap({ $0 }) {
            for sub in ["\(name).svg", "Zodiac/\(name).svg"] {
                let url = base.appendingPathComponent(sub)
                if FileManager.default.fileExists(atPath: url.path) { return url }
            }
        }
        return nil
    }
    guard let url = locate(), let src = NSImage(contentsOf: url) else { return nil }
    // Rasterize to a 40×40 bitmap (2× for Retina), tinted white via sourceAtop.
    let bitmapSize = NSSize(width: 40, height: 40)
    let tinted = NSImage(size: bitmapSize)
    tinted.lockFocus()
    src.draw(in: NSRect(origin: .zero, size: bitmapSize),
             from: NSRect(origin: .zero, size: src.size),
             operation: .copy, fraction: 1.0)
    NSColor.white.withAlphaComponent(0.85).setFill()
    NSRect(origin: .zero, size: bitmapSize).fill(using: .sourceAtop)
    tinted.unlockFocus()
    return Image(nsImage: tinted)
}

private let planetGlyphs: [String: String] = [
    "sun":        "☉",
    "moon":       "☽",
    "mercury":    "☿",
    "venus":      "♀",
    "mars":       "♂",
    "jupiter":    "♃",
    "saturn":     "♄",
    "uranus":     "♅",
    "neptune":    "♆",
    "pluto":      "♇",
    "north_node": "☊",
    "south_node": "☋",
    "chiron":     "⚷",
    "lilith":     "⚸",
]

private let aspectColors: [String: Color] = [
    // Major — keyed to brand palette
    "conjunction":    Color(red: 0.910, green: 0.961, blue: 1.000),  // brand pearl #E8F5FF
    "sextile":        Color(red: 0.298, green: 0.788, blue: 0.941),  // personality cyan #4CC9F0
    "square":         Color(red: 1.000, green: 0.220, blue: 0.702),  // design magenta #FF38B3
    "trine":          Color(red: 0.722, green: 0.647, blue: 0.898),  // brand lavender #B8A5E5
    "opposition":     Color(red: 1.000, green: 0.420, blue: 0.208),  // orange #FF6B35
    // Minor — pulled from brand family, kept lighter
    "quincunx":       Color(red: 1.000, green: 0.839, blue: 0.039),  // gold #FFD60A
    "semisextile":    Color(red: 0.200, green: 0.750, blue: 0.550),  // teal-green
    "semisquare":     Color(red: 0.969, green: 0.145, blue: 0.522),  // generator pink #F72585
    "sesquiquadrate": Color(red: 0.969, green: 0.145, blue: 0.522),  // generator pink #F72585
    "quintile":       Color(red: 0.616, green: 0.847, blue: 0.969),  // brand cyan #9DD8F7
    "biquintile":     Color(red: 0.616, green: 0.847, blue: 0.969),  // brand cyan #9DD8F7
]

private let aspectOpacity: [String: Double] = [
    // Major — neon glow against dark background
    "conjunction":    0.70,
    "sextile":        0.60,
    "square":         0.60,
    "trine":          0.55,
    "opposition":     0.55,
    // Minor — present but subordinate
    "quincunx":       0.30,
    "semisextile":    0.25,
    "semisquare":     0.25,
    "sesquiquadrate": 0.25,
    "quintile":       0.25,
    "biquintile":     0.25,
]

private let houseAxisLabels: [Int: String] = [1: "ASC", 4: "IC", 7: "DSC", 10: "MC"]

// Ring fractions (fraction of R, the wheel radius)
private enum Ring {
    static let outer:   Double = 0.98
    static let zodiac:  Double = 0.86
    static let houses:  Double = 0.74
    static let planets: Double = 0.62
    static let aspects: Double = 0.45
}

// MARK: - WheelGeometry

/// Converts raw ecliptic longitudes → screen angles.
/// Convention: ASC → π (9 o'clock); zodiac increases counter-clockwise.
private struct WheelGeometry {
    let ascLon: Double  // ecliptic longitude of house 1 cusp

    /// Ecliptic longitude → screen angle (radians).
    func screenAngle(_ lon: Double) -> Double {
        let delta = ((lon - ascLon).truncatingRemainder(dividingBy: 360) + 360)
            .truncatingRemainder(dividingBy: 360)
        return Double.pi - delta * .pi / 180
    }

    func point(cx: Double, cy: Double, r: Double, lon: Double) -> CGPoint {
        let a = screenAngle(lon)
        return CGPoint(x: cx + cos(a) * r, y: cy + sin(a) * r)
    }
}

// MARK: - AstrologyWheelView

struct AstrologyWheelView: View {
    let astrology: AstrologyData

    var body: some View {
        ZStack {
            Color.wheelBg.ignoresSafeArea()
            Canvas { ctx, size in
                let cx = size.width  / 2
                let cy = size.height / 2
                let R  = min(cx, cy) * 0.94

                // True ASC for wheel orientation (Whole Sign house_1 = sign start,
                // not the rising degree; "asc" key is always the actual degree).
                let ascLon = astrology.houses["asc"] ?? astrology.houses["house_1"] ?? 0.0
                let geo    = WheelGeometry(ascLon: ascLon)

                // Sorted planet list (by key so draw order is stable)
                let sortedPlanets = astrology.planets.sorted { $0.key < $1.key }

                // Precompute aspect-ring positions for chord drawing
                var planetScreenPos: [String: CGPoint] = [:]
                for (key, p) in sortedPlanets {
                    let r = R * Ring.aspects
                    let a = geo.screenAngle(p.longitude)
                    planetScreenPos[key] = CGPoint(x: cx + cos(a) * r, y: cy + sin(a) * r)
                }

                // ── 1. Aspect chords ───────────────────────────────────────
                for asp in astrology.aspects {
                    let k1 = asp.planet1.lowercased().replacingOccurrences(of: " ", with: "_")
                    let k2 = asp.planet2.lowercased().replacingOccurrences(of: " ", with: "_")
                    guard let pa = planetScreenPos[k1], let pb = planetScreenPos[k2] else { continue }
                    let color = aspectColors[asp.aspect] ?? .white
                    let opacity = aspectOpacity[asp.aspect] ?? 0.30
                    var path = Path()
                    path.move(to: pa)
                    path.addLine(to: pb)
                    ctx.stroke(path, with: .color(color.opacity(opacity)), lineWidth: 0.8)
                }

                // ── 2. Ring circles — neon cyan, varying weight ────────────
                let ringStyles: [(Double, Double)] = [
                    (Ring.outer,   0.55),
                    (Ring.zodiac,  0.45),
                    (Ring.houses,  0.35),
                    (Ring.planets, 0.25),
                ]
                for (frac, opacity) in ringStyles {
                    let r = CGFloat(R * frac)
                    ctx.stroke(
                        Path(ellipseIn: CGRect(x: cx - r, y: cy - r, width: r * 2, height: r * 2)),
                        with: .color(Color.neonCyan.opacity(opacity)),
                        lineWidth: 0.8
                    )
                }

                // ── 3. Sign sector fills ───────────────────────────────────
                let center = CGPoint(x: cx, y: cy)
                for (idx, sign) in signNames.enumerated() {
                    let startLon = Double(idx) * 30.0
                    let endLon   = startLon + 30.0
                    let fill = elementFill[sign] ?? Color.white.opacity(0.06)
                    let path = ringArc(
                        center: center,
                        inner: CGFloat(R * Ring.zodiac),
                        outer: CGFloat(R * Ring.outer),
                        from: geo.screenAngle(startLon),
                        to:   geo.screenAngle(endLon)
                    )
                    ctx.fill(path, with: .color(fill))
                }

                // ── 4. Sign icons (SVG if loaded, 3-letter fallback) ───────
                let iconR = R * (Ring.zodiac + Ring.outer) / 2
                let iconSize: CGFloat = 20
                for (idx, img) in zodiacImages.enumerated() {
                    let midLon = Double(idx) * 30.0 + 15.0
                    let pt = geo.point(cx: cx, cy: cy, r: iconR, lon: midLon)
                    if let img {
                        let resolved = ctx.resolve(img)
                        ctx.draw(resolved, in: CGRect(x: pt.x - iconSize / 2, y: pt.y - iconSize / 2,
                                                      width: iconSize, height: iconSize))
                    } else {
                        let t = Text(signNames[idx])
                            .font(.system(size: 12, weight: .medium))
                            .foregroundStyle(Color.white.opacity(0.85))
                        ctx.draw(ctx.resolve(t), at: pt)
                    }
                }

                // ── 5. Degree ticks (72 × 5°, major at sign boundaries) ───
                for i in 0..<72 {
                    let lon = Double(i) * 5.0
                    let major = (i % 6 == 0)
                    let inset: Double = major ? 0.072 : 0.036
                    let outerR = R * Ring.outer
                    let innerR = R * (Ring.outer - inset)
                    let a = geo.screenAngle(lon)
                    var path = Path()
                    path.move(to: CGPoint(x: cx + cos(a) * innerR, y: cy + sin(a) * innerR))
                    path.addLine(to: CGPoint(x: cx + cos(a) * outerR, y: cy + sin(a) * outerR))
                    ctx.stroke(path,
                               with: .color(major
                                   ? Color.neonCyan.opacity(0.65)
                                   : Color.brandCyan.opacity(0.18)),
                               lineWidth: major ? 1.0 : 0.5)
                }

                // ── 6. House cusp lines ────────────────────────────────────
                let houseKeys = (1...12).map { "house_\($0)" }
                let cuspLons  = houseKeys.compactMap { astrology.houses[$0] }

                for (i, lon) in cuspLons.enumerated() {
                    let fromR = R * Ring.zodiac
                    let toR   = R * Ring.houses
                    let a = geo.screenAngle(lon)
                    let major = houseAxisLabels[i + 1] != nil
                    var path = Path()
                    path.move(to: CGPoint(x: cx + cos(a) * fromR, y: cy + sin(a) * fromR))
                    path.addLine(to: CGPoint(x: cx + cos(a) * toR,   y: cy + sin(a) * toR))
                    ctx.stroke(path,
                               with: .color(major
                                   ? Color.neonCyan.opacity(0.80)
                                   : Color.brandCyan.opacity(0.22)),
                               lineWidth: major ? 1.2 : 0.5)
                }

                // ── 7. House numbers + axis labels ─────────────────────────
                let numR = R * (Ring.houses * 0.55 + Ring.aspects * 0.45)
                for (i, lon) in cuspLons.enumerated() {
                    let houseNum = i + 1
                    let nextLon  = cuspLons[(i + 1) % cuspLons.count]
                    let mid = midLongitude(from: lon, to: nextLon)
                    let numPt = geo.point(cx: cx, cy: cy, r: numR, lon: mid)

                    let numText = Text(verbatim: "\(houseNum)")
                        .font(.system(size: 10, weight: .light, design: .default))
                        .foregroundStyle(Color.brandLavender.opacity(0.45))
                    ctx.draw(ctx.resolve(numText), at: numPt)

                    if let label = houseAxisLabels[houseNum] {
                        let axR = R * Ring.houses - 18
                        let axPt = geo.point(cx: cx, cy: cy, r: axR, lon: lon)
                        let axText = Text(label)
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundStyle(Color.neonCyan.opacity(0.90))
                        ctx.draw(ctx.resolve(axText), at: axPt)
                    }
                }

                // ── 8 & 9. Planet dots, glyphs, retrograde ℞ ──────────────
                let pR = R * Ring.planets
                for (key, planet) in sortedPlanets {
                    let a  = geo.screenAngle(planet.longitude)
                    let pt = CGPoint(x: cx + cos(a) * pR, y: cy + sin(a) * pR)

                    // Dot at planet ring — neon cyan
                    let dotR: CGFloat = 3.0
                    ctx.fill(
                        Path(ellipseIn: CGRect(x: pt.x - dotR, y: pt.y - dotR,
                                               width: dotR * 2, height: dotR * 2)),
                        with: .color(Color.neonCyan.opacity(0.90))
                    )

                    // Glyph: offset outward by +22 — brand pearl
                    let glR  = pR + 22
                    let glPt = CGPoint(x: cx + cos(a) * glR, y: cy + sin(a) * glR)
                    let glyph = planetGlyphs[key] ?? "?"
                    let glText = Text(glyph)
                        .font(.system(size: 18))
                        .foregroundStyle(Color.brandPearl.opacity(0.95))
                    ctx.draw(ctx.resolve(glText), at: glPt)

                    // Retrograde ℞: neon magenta
                    if planet.retrograde {
                        let rR  = pR - 22
                        let rPt = CGPoint(x: cx + cos(a) * rR, y: cy + sin(a) * rR)
                        let rText = Text("℞")
                            .font(.system(size: 11))
                            .foregroundStyle(Color.neonMagenta.opacity(0.85))
                        ctx.draw(ctx.resolve(rText), at: rPt)
                    }
                }
            }
        }
    }
}

// MARK: - Canvas helpers

/// Annular arc path between innerR and outerR, sweeping counter-clockwise
/// from `from` to `to` (angles in radians, zodiac convention: `from` > `to`).
private func ringArc(center: CGPoint, inner: CGFloat, outer: CGFloat,
                     from a1: Double, to a2: Double) -> Path {
    var path = Path()
    path.addArc(center: center, radius: outer,
                startAngle: .radians(a1), endAngle: .radians(a2), clockwise: true)
    path.addArc(center: center, radius: inner,
                startAngle: .radians(a2), endAngle: .radians(a1), clockwise: false)
    path.closeSubpath()
    return path
}

/// Midpoint longitude between two house cusps (going forward in zodiac order).
private func midLongitude(from lon1: Double, to lon2: Double) -> Double {
    var end = lon2
    if end < lon1 { end += 360.0 }
    return (lon1 + end) / 2.0
}

// MARK: - Preview

#Preview {
    AstrologyWheelView(astrology: .previewSample)
        .frame(width: 600, height: 600)
}

// MARK: - Preview data

extension AstrologyData {
    static let previewSample: AstrologyData = {
        // Planets at fixed longitudes for layout testing
        let planets: [String: PlanetData] = [
            "sun":        PlanetData(sign: "Cap", longitude: 285, latitude: 0, speed:  1.0, retrograde: false, house: 10),
            "moon":       PlanetData(sign: "Gem", longitude: 122, latitude: 0, speed: 13.0, retrograde: false, house:  3),
            "mercury":    PlanetData(sign: "Sag", longitude: 271, latitude: 0, speed:  1.5, retrograde: false, house:  9),
            "venus":      PlanetData(sign: "Cap", longitude: 302, latitude: 0, speed:  1.2, retrograde: false, house: 10),
            "mars":       PlanetData(sign: "Lib", longitude: 198, latitude: 0, speed:  0.7, retrograde: false, house:  7),
            "jupiter":    PlanetData(sign: "Gem", longitude:  85, latitude: 0, speed:  0.1, retrograde: false, house:  3),
            "saturn":     PlanetData(sign: "Can", longitude: 155, latitude: 0, speed:  0.1, retrograde:  true, house:  5),
            "uranus":     PlanetData(sign: "Sco", longitude: 215, latitude: 0, speed:  0.0, retrograde:  true, house:  7),
            "neptune":    PlanetData(sign: "Sag", longitude: 261, latitude: 0, speed:  0.0, retrograde: false, house:  9),
            "pluto":      PlanetData(sign: "Lib", longitude: 195, latitude: 0, speed:  0.0, retrograde:  true, house:  7),
            "north_node": PlanetData(sign: "Lib", longitude: 188, latitude: 0, speed: -0.1, retrograde:  true, house:  6),
            "south_node": PlanetData(sign: "Ari", longitude:   8, latitude: 0, speed: -0.1, retrograde:  true, house: 12),
            "chiron":     PlanetData(sign: "Tau", longitude:  52, latitude: 0, speed:  0.1, retrograde: false, house:  1),
            "lilith":     PlanetData(sign: "Gem", longitude: 103, latitude: 0, speed:  0.1, retrograde: false, house:  3),
        ]

        // Equal houses from ASC at 0° Aries for clean preview
        var houses: [String: Double] = [:]
        for i in 1...12 { houses["house_\(i)"] = Double((i - 1) * 30) }
        houses["asc"] = 0.0
        houses["mc"]  = 270.0

        let aspects: [AspectData] = [
            AspectData(planet1: "Sun",  planet2: "Moon",    aspect: "trine",       orb: 3.0, applying: false),
            AspectData(planet1: "Sun",  planet2: "Jupiter", aspect: "sextile",     orb: 2.5, applying: false),
            AspectData(planet1: "Mars", planet2: "Saturn",  aspect: "square",      orb: 4.0, applying: false),
            AspectData(planet1: "Moon", planet2: "Neptune", aspect: "conjunction", orb: 1.5, applying: false),
        ]

        return AstrologyData(
            planets: planets,
            houses: houses,
            aspects: aspects,
            lunarPhase: LunarPhase(degreesBetweenSM: 197, moonPhase: 4, moonPhaseName: "Full Moon"),
            elements: ["Fire": 1, "Earth": 2, "Air": 5, "Water": 1],
            dominantElement: "Air",
            modalities: ["Cardinal": 3, "Fixed": 3, "Mutable": 3],
            dominantModality: "Cardinal",
            polarity: "Positive"
        )
    }()
}
