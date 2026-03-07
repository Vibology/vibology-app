import SwiftUI

// MARK: - Brand Palette (mirrors BodygraphView synthwave colors)

private extension Color {
    static let statsBg        = Color(red: 0.027, green: 0.027, blue: 0.102) // #07071A
    static let statsPanelBg   = Color(red: 0.051, green: 0.043, blue: 0.149) // #0D0B26
    static let statsDivider   = Color(red: 0.616, green: 0.847, blue: 0.969).opacity(0.10)

    // Brand gradient tones
    static let brandCyan      = Color(red: 0.616, green: 0.847, blue: 0.969) // #9DD8F7
    static let brandLavender  = Color(red: 0.722, green: 0.647, blue: 0.898) // #B8A5E5
    static let brandPearl     = Color(red: 0.910, green: 0.961, blue: 1.000) // #E8F5FF

    // Personality / design accents
    static let pCyan          = Color(red: 0.298, green: 0.788, blue: 0.941) // #4CC9F0
    static let pMagenta       = Color(red: 1.000, green: 0.220, blue: 0.702) // #FF38B3
    static let pOrange        = Color(red: 1.000, green: 0.420, blue: 0.208) // #FF6B35
    static let pPink          = Color(red: 0.969, green: 0.145, blue: 0.522) // #F72585

    // Elements — distinct synthwave hues, readable against dark bg
    static let elemFire       = Color(red: 1.000, green: 0.420, blue: 0.208) // orange  #FF6B35
    static let elemEarth      = Color(red: 0.200, green: 0.750, blue: 0.550) // teal-green
    static let elemAir        = Color(red: 0.616, green: 0.847, blue: 0.969) // brand cyan #9DD8F7
    static let elemWater      = Color(red: 0.263, green: 0.380, blue: 1.000) // deep indigo

    // Modalities — drawn from brand family
    static let modCardinal    = Color(red: 0.969, green: 0.145, blue: 0.522) // generator pink #F72585
    static let modFixed       = Color(red: 0.722, green: 0.647, blue: 0.898) // brand lavender #B8A5E5
    static let modMutable     = Color(red: 0.298, green: 0.788, blue: 0.941) // personality cyan #4CC9F0
}

private let elementColors:  [String: Color] = [
    "Fire": .elemFire, "Earth": .elemEarth, "Air": .elemAir, "Water": .elemWater,
]
private let modalityColors: [String: Color] = [
    "Cardinal": .modCardinal, "Fixed": .modFixed, "Mutable": .modMutable,
]
private let elementOrder  = ["Fire", "Earth", "Air", "Water"]
private let modalityOrder = ["Cardinal", "Fixed", "Mutable"]

// Aspect chord colors — identical to AstrologyWheelView for visual continuity
private let aspectChordColors: [String: Color] = [
    "conjunction":    .brandPearl,
    "sextile":        .pCyan,
    "square":         .pMagenta,
    "trine":          .brandLavender,
    "opposition":     .pOrange,
    "quincunx":       Color(red: 1.000, green: 0.839, blue: 0.039),
    "semisextile":    Color(red: 0.200, green: 0.750, blue: 0.550),
    "semisquare":     .pPink,
    "sesquiquadrate": .pPink,
    "quintile":       .brandCyan,
    "biquintile":     .brandCyan,
]

private let majorAspects: Set<String> = ["conjunction", "opposition", "trine", "square", "sextile"]

private let signOrder = ["Ari","Tau","Gem","Can","Leo","Vir","Lib","Sco","Sag","Cap","Aqu","Pis"]

private func signAbbr(for lon: Double) -> String {
    signOrder[Int((lon / 30).truncatingRemainder(dividingBy: 12))]
}

private func degMinStr(_ lon: Double) -> String {
    let within = lon.truncatingRemainder(dividingBy: 30)
    let d = Int(within)
    let m = Int((within - Double(d)) * 60)
    return "\(d)°\(String(format: "%02d", m))'"
}

private let planetOrder = [
    "sun","moon","mercury","venus","mars",
    "jupiter","saturn","uranus","neptune","pluto",
    "north_node","south_node","chiron","lilith",
]

private let planetGlyphMap: [String: String] = [
    "sun": "☉", "moon": "☽", "mercury": "☿", "venus": "♀", "mars": "♂",
    "jupiter": "♃", "saturn": "♄", "uranus": "♅", "neptune": "♆", "pluto": "♇",
    "north node": "☊", "north_node": "☊",
    "south node": "☋", "south_node": "☋",
    "chiron": "⚷", "lilith": "⚸",
]

// MARK: - AstrologyStatsView

struct AstrologyStatsView: View {
    let astrology: AstrologyData

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                PlanetsPanel(planets: astrology.planets)
                CuspsPanel(houses: astrology.houses)
                ElementsPanel(
                    elements: astrology.elements,
                    dominant: astrology.dominantElement ?? "",
                    polarity: astrology.polarity ?? ""
                )
                ModalitiesPanel(
                    modalities: astrology.modalities,
                    dominant: astrology.dominantModality ?? ""
                )
                AspectsPanel(aspects: astrology.aspects)
            }
            .padding(12)
        }
        .background(Color.statsBg)
    }
}

// MARK: - Planets Panel

private struct PlanetsPanel: View {
    let planets: [String: PlanetData]

    private var sorted: [(String, PlanetData)] {
        planetOrder.compactMap { k in planets[k].map { (k, $0) } }
    }

    var body: some View {
        StatsPanelCard(title: "PLANETS") {
            VStack(spacing: 0) {
                ForEach(Array(sorted.enumerated()), id: \.offset) { idx, pair in
                    let (key, planet) = pair
                    PlanetRow(planet: planet, glyph: planetGlyphMap[key] ?? "?")
                    if idx < sorted.count - 1 {
                        Color.statsDivider.frame(height: 1)
                    }
                }
            }
        }
    }
}

private struct PlanetRow: View {
    let planet: PlanetData
    let glyph: String

    var body: some View {
        HStack(spacing: 0) {
            Text(glyph)
                .font(.system(size: 15))
                .foregroundStyle(Color.brandPearl.opacity(0.90))
                .frame(width: 22, alignment: .center)

            Text(planet.sign)
                .font(.system(size: 11, weight: .medium))
                .foregroundStyle(Color.brandLavender.opacity(0.85))
                .frame(width: 30, alignment: .leading)

            Text(degMinStr(planet.longitude))
                .font(.system(size: 11).monospacedDigit())
                .foregroundStyle(Color.brandPearl.opacity(0.65))
                .frame(maxWidth: .infinity, alignment: .leading)

            Text(planet.retrograde ? "℞" : "")
                .font(.system(size: 10))
                .foregroundStyle(Color.pMagenta.opacity(0.80))
                .frame(width: 16, alignment: .center)

            Text("H\(planet.house)")
                .font(.system(size: 10).monospacedDigit())
                .foregroundStyle(Color.pCyan.opacity(0.55))
                .frame(width: 26, alignment: .trailing)
        }
        .padding(.vertical, 4)
        .padding(.horizontal, 4)
    }
}

// MARK: - Cusps Panel

private struct CuspsPanel: View {
    let houses: [String: Double]

    private var cusps: [(Int, Double)] {
        (1...12).compactMap { n in houses["house_\(n)"].map { (n, $0) } }
    }

    var body: some View {
        StatsPanelCard(title: "CUSPS") {
            HStack(alignment: .top, spacing: 8) {
                VStack(alignment: .leading, spacing: 5) {
                    ForEach(cusps.prefix(6), id: \.0) { n, lon in
                        CuspRow(n: n, sign: signAbbr(for: lon), deg: degMinStr(lon))
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                VStack(alignment: .leading, spacing: 5) {
                    ForEach(Array(cusps.dropFirst(6).prefix(6)), id: \.0) { n, lon in
                        CuspRow(n: n, sign: signAbbr(for: lon), deg: degMinStr(lon))
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(maxWidth: .infinity)
        }
    }
}

private let axisLabels: [Int: String] = [1: "ASC", 4: "IC", 7: "DSC", 10: "MC"]

private struct CuspRow: View {
    let n: Int
    let sign: String
    let deg: String

    var body: some View {
        HStack(spacing: 4) {
            Group {
                if let axis = axisLabels[n] {
                    Text(axis)
                        .font(.system(size: 9, weight: .bold))
                        .foregroundStyle(Color.pCyan.opacity(0.90))
                } else {
                    Text("H\(n)")
                        .font(.system(size: 10).monospacedDigit())
                        .foregroundStyle(Color.brandLavender.opacity(0.50))
                }
            }
            .frame(width: 26, alignment: .leading)

            Text(sign)
                .font(.system(size: 10, weight: .medium))
                .foregroundStyle(Color.brandLavender.opacity(0.80))
                .lineLimit(1)
                .frame(width: 28, alignment: .leading)

            Text(deg)
                .font(.system(size: 10).monospacedDigit())
                .foregroundStyle(Color.brandPearl.opacity(0.60))
        }
    }
}

// MARK: - Elements Panel

private struct ElementsPanel: View {
    let elements: [String: Int]
    let dominant: String
    let polarity: String

    private var total: Int { max(1, elements.values.reduce(0, +)) }

    var body: some View {
        StatsPanelCard(title: "ELEMENTS") {
            VStack(spacing: 9) {
                ForEach(elementOrder, id: \.self) { name in
                    DistributionRow(
                        label: name,
                        count: elements[name] ?? 0,
                        total: total,
                        color: elementColors[name] ?? .white,
                        isDominant: name == dominant
                    )
                }
                if !polarity.isEmpty {
                    Color.statsDivider
                        .frame(height: 1)
                        .padding(.vertical, 3)
                    HStack {
                        Text("POLARITY")
                            .font(.system(size: 10, weight: .semibold))
                            .tracking(1.5)
                            .foregroundStyle(Color.white.opacity(0.35))
                        Spacer()
                        Text(polarity.uppercased())
                            .font(.system(size: 13, weight: .semibold))
                            .tracking(1.0)
                            .foregroundStyle(polarity == "Positive" ? Color.elemAir : Color.elemEarth)
                    }
                }
            }
        }
    }
}

// MARK: - Modalities Panel

private struct ModalitiesPanel: View {
    let modalities: [String: Int]
    let dominant: String

    private var total: Int { max(1, modalities.values.reduce(0, +)) }

    var body: some View {
        StatsPanelCard(title: "QUALITIES") {
            VStack(spacing: 9) {
                ForEach(modalityOrder, id: \.self) { name in
                    DistributionRow(
                        label: name,
                        count: modalities[name] ?? 0,
                        total: total,
                        color: modalityColors[name] ?? .white,
                        isDominant: name == dominant
                    )
                }
            }
        }
    }
}

// MARK: - Shared Distribution Row

private struct DistributionRow: View {
    let label: String
    let count: Int
    let total: Int
    let color: Color
    let isDominant: Bool

    var body: some View {
        HStack(spacing: 10) {
            Text(label)
                .font(.system(size: 13, weight: isDominant ? .semibold : .regular))
                .foregroundStyle(isDominant ? color : Color.white.opacity(0.50))
                .frame(width: 68, alignment: .leading)

            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 2.5)
                        .fill(Color.white.opacity(0.07))
                        .frame(height: 6)
                    RoundedRectangle(cornerRadius: 2.5)
                        .fill(color.opacity(isDominant ? 0.85 : 0.42))
                        .frame(
                            width: geo.size.width * CGFloat(count) / CGFloat(total),
                            height: 6
                        )
                }
                .frame(height: 6)
                .frame(maxHeight: .infinity, alignment: .center)
            }
            .frame(height: 18)

            Text("\(count)")
                .font(.system(size: 13, weight: .medium).monospacedDigit())
                .foregroundStyle(isDominant ? color : Color.white.opacity(0.35))
                .frame(width: 18, alignment: .trailing)
        }
    }
}

// MARK: - Aspects Panel

private struct AspectsPanel: View {
    let aspects: [AspectData]

    private var sorted: [AspectData] {
        let majorOrder = ["conjunction", "opposition", "trine", "square", "sextile"]
        func rank(_ a: AspectData) -> Int { majorOrder.firstIndex(of: a.aspect) ?? 99 }
        return aspects.sorted { (rank($0), $0.orb) < (rank($1), $1.orb) }
    }

    var body: some View {
        StatsPanelCard(title: "ASPECTS") {
            VStack(spacing: 0) {
                ForEach(Array(sorted.enumerated()), id: \.offset) { idx, asp in
                    AspectRow(asp: asp)
                    if idx < sorted.count - 1 {
                        Color.statsDivider.frame(height: 1)
                    }
                }
            }
        }
    }
}

private struct AspectRow: View {
    let asp: AspectData

    private func glyph(for name: String) -> String {
        let key = name.lowercased().replacingOccurrences(of: " ", with: "_")
        return planetGlyphMap[key] ?? String(name.prefix(2))
    }

    private var isMajor: Bool { majorAspects.contains(asp.aspect) }
    private var color: Color { aspectChordColors[asp.aspect] ?? .white }

    var body: some View {
        HStack(spacing: 0) {
            // Aspect color pill
            RoundedRectangle(cornerRadius: 2)
                .fill(color.opacity(isMajor ? 0.85 : 0.55))
                .frame(width: 3, height: 26)
                .padding(.trailing, 8)

            // Planet 1 glyph
            Text(glyph(for: asp.planet1))
                .font(.system(size: 16))
                .foregroundStyle(Color.white.opacity(0.85))
                .frame(width: 22, alignment: .center)

            // Aspect name — fixed width, centered
            Text(asp.aspect.capitalized)
                .font(.system(size: 12, weight: isMajor ? .medium : .regular))
                .foregroundStyle(color.opacity(isMajor ? 0.90 : 0.60))
                .frame(width: 96, alignment: .center)

            // Planet 2 glyph
            Text(glyph(for: asp.planet2))
                .font(.system(size: 16))
                .foregroundStyle(Color.white.opacity(0.85))
                .frame(width: 22, alignment: .center)

            Spacer(minLength: 6)

            // Orb
            Text(String(format: "%.1f°", asp.orb))
                .font(.system(size: 11).monospacedDigit())
                .foregroundStyle(Color.white.opacity(0.32))
                .frame(width: 34, alignment: .trailing)

            // Applying ▲ / Separating ▽
            Text(asp.applying ? "▲" : "▽")
                .font(.system(size: 9))
                .foregroundStyle(
                    asp.applying
                        ? Color.elemEarth.opacity(0.80)
                        : Color.white.opacity(0.22)
                )
                .frame(width: 14, alignment: .center)
        }
        .padding(.vertical, 6)
        .padding(.horizontal, 4)
    }
}

// MARK: - Panel Card Container

private struct StatsPanelCard<Content: View>: View {
    let title: String
    @ViewBuilder let content: () -> Content

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.system(size: 10, weight: .semibold))
                .tracking(2.5)
                .foregroundStyle(Color.brandCyan.opacity(0.60))

            content()
        }
        .padding(12)
        .background(Color.statsPanelBg)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

// MARK: - Preview

#Preview {
    AstrologyStatsView(astrology: AstrologyData.previewSample)
        .frame(width: 220, height: 700)
}
