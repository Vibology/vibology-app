import SwiftUI

// MARK: - Synthwave Palette

private extension Color {
    static let bgDeep          = Color(red: 0.027, green: 0.027, blue: 0.102) // #07071A
    static let bgMid           = Color(red: 0.051, green: 0.043, blue: 0.149) // #0D0B26
    static let channelOn       = Color(red: 0.298, green: 0.788, blue: 0.941) // #4CC9F0 cyan  (personality)
    static let channelDesign   = Color(red: 1.000, green: 0.220, blue: 0.702) // #FF38B3 magenta (design)
    static let splitAccentB    = Color(red: 0.267, green: 0.533, blue: 1.000) // #4488ff

    // Defined center fills — synthwave takes on Jovian Archive color families
    // Gold   (ref #F9F6A9): Head, G-Center           — consciousness / identity
    static let centerGoldTop    = Color(red: 1.000, green: 0.851, blue: 0.239) // #FFD93D
    static let centerGoldBot    = Color(red: 0.957, green: 0.635, blue: 0.165) // #F4A22A
    // Teal   (ref #668E82): Ajna                     — mental awareness
    static let centerTealTop    = Color(red: 0.239, green: 0.800, blue: 0.667) // #3DCCAA
    static let centerTealBot    = Color(red: 0.102, green: 0.604, blue: 0.478) // #1A9A7A
    // Crimson (ref #493A36): Throat, Spleen, SP, Root — awareness / pressure / motor
    static let centerCrimsonTop = Color(red: 0.600, green: 0.200, blue: 0.320) // #993352
    static let centerCrimsonBot = Color(red: 0.380, green: 0.100, blue: 0.200) // #611933
    // Rose   (ref #BA4C43): Heart/Ego, Sacral         — energy / motor
    static let centerRoseTop    = Color(red: 0.910, green: 0.220, blue: 0.282) // #E83848
    static let centerRoseBot    = Color(red: 0.722, green: 0.118, blue: 0.157) // #B81E28
    // Undefined center fill — medium bluish-grey
    static let centerUndefined  = Color(red: 0.28, green: 0.28, blue: 0.33) // ~#474754

    static let accentGenerator  = Color(red: 0.969, green: 0.145, blue: 0.522) // #F72585
    static let accentMG         = Color(red: 1.000, green: 0.420, blue: 0.208) // #FF6B35
    static let accentProjector  = Color(red: 1.000, green: 0.839, blue: 0.039) // #FFD60A
    static let accentManifestor = Color(red: 0.902, green: 0.224, blue: 0.275) // #E63946
    static let accentReflector  = Color(red: 0.753, green: 0.753, blue: 0.753) // #C0C0C0
}

// MARK: - HangingInfo

private struct HangingInfo {
    let gate: Int
    let isPersonality: Bool
    let isDesign: Bool
}

// MARK: - Path direction helper

/// Returns the gate number that sits at t=0 of `rawPath` (SVG coordinates).
/// Compares the path's first move-to point against the known SVG positions of
/// the two gates named in `svgID` and picks the closer one.
/// Falls back to the first number in the id if positions are unavailable.
private func pathStartGate(svgID: String, rawPath: Path, layout: BodygraphData) -> Int {
    let parts = svgID.split(separator: "-").compactMap { Int($0) }
    guard parts.count == 2 else { return parts.first ?? 0 }
    let (g1, g2) = (parts[0], parts[1])
    guard let pos1 = layout.gatePositions[g1],
          let pos2 = layout.gatePositions[g2] else { return g1 }

    var pathStart: CGPoint? = nil
    rawPath.forEach { element in
        guard pathStart == nil else { return }
        if case .move(let to) = element { pathStart = to }
    }
    guard let ps = pathStart else { return g1 }
    let d1 = hypot(ps.x - pos1.x, ps.y - pos1.y)
    let d2 = hypot(ps.x - pos2.x, ps.y - pos2.y)
    return d1 <= d2 ? g1 : g2
}

/// Returns the approximate CGPoint at parametric position t ∈ [0,1] along `path`.
/// Slices a tiny trimmed segment and returns its bounding rect midpoint.
private func pointOnPath(_ path: Path, at t: CGFloat) -> CGPoint {
    let clamped = min(max(t, 0.001), 0.999)
    let ε: CGFloat = 0.002
    let segment = path.trimmedPath(from: max(0, clamped - ε), to: min(1, clamped + ε))
    let r = segment.boundingRect
    return CGPoint(x: r.midX, y: r.midY)
}

// MARK: - BodygraphView

struct BodygraphView: View {
    let data: HumanDesignData
    var scale: CGFloat = 1.0
    // MARK: - Derived state

    private var personalityGateSet: Set<Int> {
        Set(data.planets.personality.values.map { $0.gate })
    }

    private var designGateSet: Set<Int> {
        Set(data.planets.design.values.map { $0.gate })
    }

    /// SVG channel ids for fully defined channels (e.g. "59-6")
    private var activeChannelSVGIDs: Set<String> {
        let layout = BodygraphData.shared
        var ids = Set<String>()
        for ch in data.channels {
            let raw = (ch.split(separator: ":").first.map(String.init) ?? ch)
                .trimmingCharacters(in: .whitespaces)
            let parts = raw.split(separator: "/")
                .compactMap { Int($0.trimmingCharacters(in: .whitespaces)) }
            guard parts.count == 2 else { continue }
            let key = "\(min(parts[0], parts[1]))-\(max(parts[0], parts[1]))"
            if let svgID = layout.channelBySortedPair[key] { ids.insert(svgID) }
        }
        return ids
    }

    /// Gate numbers that appear in fully defined channels
    private var activeGateIDs: Set<Int> {
        activeChannelSVGIDs.flatMap { id in
            id.split(separator: "-").compactMap { Int($0) }
        }.reduce(into: Set<Int>()) { $0.insert($1) }
    }

    /// Planet gates NOT part of a fully defined channel
    private var hangingGateIDs: Set<Int> {
        personalityGateSet.union(designGateSet).subtracting(activeGateIDs)
    }

    /// SVG channel id → hanging gate activation info.
    /// Key = channelSVGID that shows the hanging half-stroke.
    private var hangingInfoByChannel: [String: HangingInfo] {
        let layout  = BodygraphData.shared
        let hanging = hangingGateIDs
        let active  = activeChannelSVGIDs
        let pGates  = personalityGateSet
        let dGates  = designGateSet
        var result: [String: HangingInfo] = [:]
        for gate in hanging {
            // Use only the first non-active channel for this gate.
            // Integration Circuit gates (20, 57, 10, 34) each appear in 2–3 channels;
            // without this guard every channel would render a separate half-stroke.
            guard let channelID = (layout.channelsByGate[gate] ?? [])
                    .first(where: { !active.contains($0) }) else { continue }
            let isP = pGates.contains(gate)
            let isD = dGates.contains(gate)
            if let existing = result[channelID] {
                // Two hanging gates share this channel — merge their activation flags.
                result[channelID] = HangingInfo(
                    gate: existing.gate,
                    isPersonality: existing.isPersonality || isP,
                    isDesign: existing.isDesign || isD
                )
            } else {
                result[channelID] = HangingInfo(gate: gate, isPersonality: isP, isDesign: isD)
            }
        }
        return result
    }

    /// SVG centre ids for defined centres
    private var definedCenterSVGIDs: Set<String> {
        Set(data.definition.definedCenters.compactMap { BodygraphData.apiCenterToSVGID[$0] })
    }

    /// BFS over active channels → connected components among defined centres.
    /// Multiple components = split definition.
    private var splitComponents: [Set<String>] {
        let definedSet = definedCenterSVGIDs
        guard !definedSet.isEmpty else { return [] }

        var adj: [String: Set<String>] = Dictionary(
            uniqueKeysWithValues: definedSet.map { ($0, []) }
        )
        for ch in data.channels {
            let raw = (ch.split(separator: ":").first.map(String.init) ?? ch)
                .trimmingCharacters(in: .whitespaces)
            let parts = raw.split(separator: "/")
                .compactMap { Int($0.trimmingCharacters(in: .whitespaces)) }
            guard parts.count == 2,
                  let abbr1 = BodygraphData.gateToCenter[parts[0]],
                  let abbr2 = BodygraphData.gateToCenter[parts[1]],
                  let svg1  = BodygraphData.centerAbbrevToSVGID[abbr1],
                  let svg2  = BodygraphData.centerAbbrevToSVGID[abbr2],
                  definedSet.contains(svg1),
                  definedSet.contains(svg2) else { continue }
            adj[svg1]?.insert(svg2)
            adj[svg2]?.insert(svg1)
        }

        var visited    = Set<String>()
        var components: [Set<String>] = []
        for start in definedSet {
            guard !visited.contains(start) else { continue }
            var component = Set<String>()
            var queue = [start]
            while !queue.isEmpty {
                let node = queue.removeFirst()
                guard !visited.contains(node) else { continue }
                visited.insert(node); component.insert(node)
                for neighbour in adj[node] ?? [] where !visited.contains(neighbour) {
                    queue.append(neighbour)
                }
            }
            components.append(component)
        }
        return components.sorted { $0.count > $1.count }
    }

    private var typeAccentColor: Color {
        switch data.type.energyType {
        case "Generator":             return .accentGenerator
        case "Manifesting Generator": return .accentMG
        case "Projector":             return .accentProjector
        case "Manifestor":            return .accentManifestor
        case "Reflector":             return .accentReflector
        default:                      return .accentGenerator
        }
    }

    // MARK: - Body

    var body: some View {
        // Resolve before Canvas to avoid Swift 6 captures of self
        let active       = activeChannelSVGIDs
        let activeGates  = activeGateIDs
        let hangingInfo  = hangingInfoByChannel
        let hangingGates = hangingGateIDs
        let defined      = definedCenterSVGIDs
        let pGates       = personalityGateSet
        let dGates       = designGateSet

        return ZStack {
            LinearGradient(colors: [.bgDeep, .bgMid], startPoint: .top, endPoint: .bottom)

            TimelineView(.animation) { timeline in
            Canvas { ctx, sz in
                let layout = BodygraphData.shared

                // Scale 1500×2169 source to canvas, centred with margin
                let margin: CGFloat = 10
                let scale = min((sz.width  - margin * 2) / 1500,
                                (sz.height - margin * 2) / 2169)
                let tx    = (sz.width  - 1500 * scale) / 2
                let ty    = (sz.height - 2169 * scale) / 2
                let xform = CGAffineTransform(translationX: tx, y: ty)
                                .scaledBy(x: scale, y: scale)

                let channelW: CGFloat = 13 * scale

                // 1 ─ Body silhouette
                let bodyPath = layout.bodyOutline.applying(xform)
                ctx.fill(bodyPath,   with: .color(.white.opacity(0.04)))
                ctx.stroke(bodyPath, with: .color(.white.opacity(0.10)), lineWidth: 4 * scale)

                // 2 ─ Inactive channel strokes
                //     Drawn into an isolated layer so channels that share a junction
                //     (e.g. the four Integration Circuit channels at ~317,1324) don't
                //     compound opacity. All strokes are white inside the layer; the
                //     whole layer is then composited at 7% opacity as a flat image.
                var inactiveCtx = ctx
                inactiveCtx.opacity = 0.07
                inactiveCtx.drawLayer { layerCtx in
                    for (svgID, rawPath) in layout.channelPaths {
                        guard !active.contains(svgID) else { continue }
                        layerCtx.stroke(rawPath.applying(xform),
                                        with: .color(.white),
                                        lineWidth: channelW)
                    }
                }

                // 3 ─ Hanging gate half-strokes (solid, overlaid on the inactive gray)
                //
                // pathStartGate() compares the path's actual first point against known gate
                // positions — never relies on the SVG id naming convention, which doesn't
                // guarantee the draw direction matches the id order.
                //   trimmedPath(0, 0.5) → t=0 end (path start)
                //   trimmedPath(0.5, 1) → t=1 end (path end)
                //
                // Dual activation (same gate in both personality AND design) → dashed.
                for (svgID, info) in hangingInfo {
                    guard let rawPath = layout.channelPaths[svgID] else { continue }
                    let p = rawPath.applying(xform)
                    let startGate = pathStartGate(svgID: svgID, rawPath: rawPath, layout: layout)
                    let half: Path = (info.gate == startGate)
                        ? p.trimmedPath(from: 0.0, to: 0.5)
                        : p.trimmedPath(from: 0.5, to: 1.0)

                    if info.isPersonality && info.isDesign {
                        // Dual activation: magenta base + dashed cyan on top
                        ctx.stroke(half, with: .color(.channelDesign.opacity(0.70)), lineWidth: channelW)
                        ctx.stroke(half, with: .color(.channelOn),
                                   style: StrokeStyle(lineWidth: channelW,
                                                      dash: [22 * scale, 22 * scale]))
                    } else if info.isPersonality {
                        ctx.stroke(half, with: .color(.channelOn.opacity(0.70)),   lineWidth: channelW)
                    } else {
                        ctx.stroke(half, with: .color(.channelDesign.opacity(0.70)), lineWidth: channelW)
                    }
                }

                // 4 ─ Active channel strokes (glow + bright)
                //
                // Each channel half is coloured by its gate's activation source:
                //   personality only  → solid cyan
                //   design only       → solid magenta
                //   both P + D        → magenta base + dashed cyan (same as hanging dual)
                // Whole-channel single-pass only when both halves are identical non-dual.
                for svgID in active {
                    guard let rawPath = layout.channelPaths[svgID] else { continue }
                    let parts = svgID.split(separator: "-").compactMap { Int($0) }
                    guard parts.count == 2 else { continue }
                    let startGate = pathStartGate(svgID: svgID, rawPath: rawPath, layout: layout)
                    let endGate   = startGate == parts[0] ? parts[1] : parts[0]
                    let p = rawPath.applying(xform)

                    let startDual  = pGates.contains(startGate) && dGates.contains(startGate)
                    let endDual    = pGates.contains(endGate)   && dGates.contains(endGate)
                    let startColor: Color = pGates.contains(startGate) ? .channelOn : .channelDesign
                    let endColor:   Color = pGates.contains(endGate)   ? .channelOn : .channelDesign

                    if !startDual && !endDual && startColor == endColor {
                        // Fast path: uniform colour, no dual activation
                        ctx.stroke(p, with: .color(startColor), lineWidth: channelW)
                    } else {
                        let firstHalf  = p.trimmedPath(from: 0.0, to: 0.5)
                        let secondHalf = p.trimmedPath(from: 0.5, to: 1.0)

                        if startDual {
                            ctx.stroke(firstHalf, with: .color(.channelDesign.opacity(0.70)), lineWidth: channelW)
                            ctx.stroke(firstHalf, with: .color(.channelOn),
                                       style: StrokeStyle(lineWidth: channelW, dash: [22 * scale, 22 * scale]))
                        } else {
                            ctx.stroke(firstHalf, with: .color(startColor), lineWidth: channelW)
                        }

                        if endDual {
                            ctx.stroke(secondHalf, with: .color(.channelDesign.opacity(0.70)), lineWidth: channelW)
                            ctx.stroke(secondHalf, with: .color(.channelOn),
                                       style: StrokeStyle(lineWidth: channelW, dash: [22 * scale, 22 * scale]))
                        } else {
                            ctx.stroke(secondHalf, with: .color(endColor), lineWidth: channelW)
                        }
                    }
                }

                // 5 ─ Particles (above channels, beneath centers)
                let elapsed    = timeline.date.timeIntervalSinceReferenceDate
                let speed      = 0.12
                let particleR: CGFloat = 4.0 * scale   // core
                let glowR:     CGFloat = 9.0 * scale   // inner halo
                let bloomR:    CGFloat = 16.0 * scale  // outer bloom

                for svgID in active {
                    guard let rawPath = layout.channelPaths[svgID] else { continue }
                    let parts = svgID.split(separator: "-").compactMap { Int($0) }
                    guard parts.count == 2 else { continue }
                    let startGate  = pathStartGate(svgID: svgID, rawPath: rawPath, layout: layout)
                    let endGate    = startGate == parts[0] ? parts[1] : parts[0]
                    let p          = rawPath.applying(xform)
                    let startColor: Color = pGates.contains(startGate) ? .channelOn : .channelDesign
                    let endColor:   Color = pGates.contains(endGate)   ? .channelOn : .channelDesign

                    for offset in [0.0, 0.125, 0.25, 0.375, 0.5, 0.625, 0.75, 0.875] {
                        let t     = CGFloat((elapsed * speed + offset).truncatingRemainder(dividingBy: 1.0))
                        let pt    = pointOnPath(p, at: t)
                        let fade  = min(t / 0.07, 1.0) * min((1.0 - t) / 0.07, 1.0)
                        let color = (startColor == endColor) ? startColor : (t < 0.5 ? startColor : endColor)
                        ctx.fill(Path(ellipseIn: CGRect(x: pt.x - bloomR,    y: pt.y - bloomR,
                                                        width: bloomR * 2,    height: bloomR * 2)),
                                 with: .color(color.opacity(0.20 * fade)))
                        ctx.fill(Path(ellipseIn: CGRect(x: pt.x - glowR,     y: pt.y - glowR,
                                                        width: glowR * 2,     height: glowR * 2)),
                                 with: .color(color.opacity(0.55 * fade)))
                        ctx.fill(Path(ellipseIn: CGRect(x: pt.x - particleR, y: pt.y - particleR,
                                                        width: particleR * 2, height: particleR * 2)),
                                 with: .color(color.opacity(1.0 * fade)))
                        ctx.fill(Path(ellipseIn: CGRect(x: pt.x - particleR * 0.4, y: pt.y - particleR * 0.4,
                                                        width: particleR * 0.8,     height: particleR * 0.8)),
                                 with: .color(Color.white.opacity(0.85 * fade)))
                    }
                }

                for (svgID, info) in hangingInfo {
                    guard let rawPath = layout.channelPaths[svgID] else { continue }
                    let p         = rawPath.applying(xform)
                    let startGate = pathStartGate(svgID: svgID, rawPath: rawPath, layout: layout)
                    let gateAtStart = (info.gate == startGate)
                    let halfPath: Path = gateAtStart
                        ? p.trimmedPath(from: 0.0, to: 0.5)
                        : p.trimmedPath(from: 0.5, to: 1.0)
                    let color: Color = info.isPersonality ? .channelOn : .channelDesign

                    for offset in [0.0, 0.25, 0.5, 0.75] {
                        let t     = CGFloat((elapsed * speed + offset).truncatingRemainder(dividingBy: 1.0))
                        // Always travel gate→outward: reverse path position when gate is at path end
                        let pathT = gateAtStart ? t : (1.0 - t)
                        let pt    = pointOnPath(halfPath, at: pathT)
                        let fade  = min(t / 0.07, 1.0) * min((1.0 - t) / 0.07, 1.0)
                        ctx.fill(Path(ellipseIn: CGRect(x: pt.x - bloomR,    y: pt.y - bloomR,
                                                        width: bloomR * 2,    height: bloomR * 2)),
                                 with: .color(color.opacity(0.20 * fade)))
                        ctx.fill(Path(ellipseIn: CGRect(x: pt.x - glowR,     y: pt.y - glowR,
                                                        width: glowR * 2,     height: glowR * 2)),
                                 with: .color(color.opacity(0.55 * fade)))
                        ctx.fill(Path(ellipseIn: CGRect(x: pt.x - particleR, y: pt.y - particleR,
                                                        width: particleR * 2, height: particleR * 2)),
                                 with: .color(color.opacity(1.0 * fade)))
                        ctx.fill(Path(ellipseIn: CGRect(x: pt.x - particleR * 0.4, y: pt.y - particleR * 0.4,
                                                        width: particleR * 0.8,     height: particleR * 0.8)),
                                 with: .color(Color.white.opacity(0.85 * fade)))
                    }
                }

                // 6 ─ Centre shapes
                //
                // Defined centers: per-center gradient fills, no stroke.
                // Color families (synthwave takes on Jovian Archive palette):
                //   Gold    — Head, G-Center
                //   Teal    — Ajna
                //   Crimson — Throat, Spleen, Solar Plexus, Root
                //   Rose    — Heart/Ego, Sacral
                //
                // Undefined centers: flat dark grey, no stroke.
                for (svgID, rawPath) in layout.centers {
                    let path      = rawPath.applying(xform)
                    let isDefined = defined.contains(svgID)

                    if isDefined {
                        let (c1, c2): (Color, Color) = {
                            switch svgID {
                            case "Head-Center", "G-Center":
                                return (.centerGoldTop,    .centerGoldBot)
                            case "Ajna-Center":
                                return (.centerTealTop,    .centerTealBot)
                            case "HeartEgo-Center", "Sacral-Center":
                                return (.centerRoseTop,    .centerRoseBot)
                            default: // Throat, Spleen, Solar-Plexus, Root
                                return (.centerCrimsonTop, .centerCrimsonBot)
                            }
                        }()
                        let bounds = path.boundingRect
                        ctx.fill(path, with: .linearGradient(
                            Gradient(colors: [c1, c2]),
                            startPoint: CGPoint(x: bounds.midX, y: bounds.minY),
                            endPoint:   CGPoint(x: bounds.midX, y: bounds.maxY)
                        ))
                    } else {
                        ctx.fill(path, with: .color(.centerUndefined))
                    }
                }

                // 6 ─ Gate labels
                drawGateLabels(ctx: ctx, layout: layout, xform: xform,
                               activeGates: activeGates,
                               pGates: pGates, dGates: dGates,
                               hangingGates: hangingGates,
                               defined: defined,
                               scale: scale)
            }
            } // TimelineView

            // 7 ─ Type/authority overlay
            typeOverlay

            // 8 ─ Variable arrows (top region, above body shoulders)
            variablesOverlay
        }
        .aspectRatio(1500.0 / 2169.0, contentMode: .fit)
        .background(Color.bgDeep)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    // MARK: - Gate Labels

    private func drawGateLabels(ctx: GraphicsContext,
                                layout: BodygraphData,
                                xform: CGAffineTransform,
                                activeGates: Set<Int>,
                                pGates: Set<Int>,
                                dGates: Set<Int>,
                                hangingGates: Set<Int>,
                                defined: Set<String>,
                                scale: CGFloat) {
        let r            = 20.0 * scale
        let fontSize     = max(5.0, 20.0 * scale)
        let fontSizeSmall = max(4.0, 16.0 * scale)

        for (gate, rawPt) in layout.gatePositions {
            let isActive  = activeGates.contains(gate)
            let isHanging = hangingGates.contains(gate)
            let centre    = rawPt.applying(xform)

            if isActive || isHanging {
                // ── Activated gate: white circle + black number ──────────────────
                let rect    = CGRect(x: centre.x - r, y: centre.y - r, width: r * 2, height: r * 2)
                let strokeW = (isActive ? 4.0 : 3.0) * scale

                ctx.fill(Path(ellipseIn: rect), with: .color(.white))

                ctx.stroke(Path(ellipseIn: rect), with: .color(.black), lineWidth: strokeW)

                let weight: Font.Weight = isActive ? .bold : .medium
                let label = Text("\(gate)")
                    .font(.system(size: fontSize, weight: weight))
                    .foregroundStyle(Color.black)
                ctx.draw(ctx.resolve(label), at: centre)

            } else {
                // ── Unactivated gate: bare number, colour adapts to center state ──
                // Undefined centers are dark grey → always use light text.
                // Defined centers: light bg (gold, teal) → dark text; dark bg → light text.
                let centerAbbrev  = BodygraphData.gateToCenter[gate] ?? ""
                let centerSVGID   = BodygraphData.centerAbbrevToSVGID[centerAbbrev] ?? ""
                let centerDefined = defined.contains(centerSVGID)
                let textColor: Color = {
                    guard centerDefined else { return Color.white.opacity(0.40) }
                    switch centerAbbrev {
                    case "HD", "GC": return Color(white: 0.15).opacity(0.80)  // gold — light bg
                    case "AA":       return Color(white: 0.15).opacity(0.75)  // teal — medium-light bg
                    case "HT", "SL": return Color.white.opacity(0.45)         // rose — medium-dark bg
                    default:         return Color.white.opacity(0.40)         // crimson — dark bg
                    }
                }()
                let label = Text("\(gate)")
                    .font(.system(size: fontSizeSmall, weight: .light))
                    .foregroundStyle(textColor)
                ctx.draw(ctx.resolve(label), at: centre)
            }
        }
    }

    // MARK: - Type Overlay

    // MARK: - Variables Overlay

    private var variablesOverlay: some View {
        let cyan     = Color(red: 0.298, green: 0.788, blue: 0.941)
        let magenta  = Color(red: 1.000, green: 0.220, blue: 0.702)
        let vars     = data.variables
        let fontSize = max(10.0, 14.0 * scale)
        let arrowGap = max(6.0,  10.0 * scale)
        return VStack(spacing: 0) {
            HStack(alignment: .top, spacing: 0) {
                // Design — left (magenta)
                VStack(alignment: .leading, spacing: 0) {
                    Text(vars.topLeft?.value    == "left" ? "<-" : "->")
                    Text(vars.bottomLeft?.value == "left" ? "<-" : "->")
                        .padding(.top, arrowGap)
                }
                .foregroundStyle(magenta)
                Spacer()
                // Personality — right (cyan)
                VStack(alignment: .trailing, spacing: 0) {
                    Text(vars.topRight?.value    == "left" ? "<-" : "->")
                    Text(vars.bottomRight?.value == "left" ? "<-" : "->")
                        .padding(.top, arrowGap)
                }
                .foregroundStyle(cyan)
            }
            .font(.system(size: fontSize, weight: .bold, design: .monospaced))
            .padding(.horizontal, 16)
            .padding(.top, 14)
            Spacer()
        }
    }

    // MARK: - Type Overlay

    private var typeOverlay: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                VStack(alignment: .trailing, spacing: 2) {
                    Text(data.type.energyType)
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundStyle(typeAccentColor)
                    Text(data.profile.profile.split(separator: ":").first.map(String.init) ?? "")
                        .font(.system(size: 9, weight: .regular))
                        .foregroundStyle(.white.opacity(0.5))
                    Text(data.authority.innerAuthority)
                        .font(.system(size: 8, weight: .regular))
                        .foregroundStyle(.white.opacity(0.4))
                }
                .padding(8)
            }
        }
    }
}

// MARK: - Preview Data

struct BodygraphPreviewData {
    // Joe Lewis — 1978-09-18 17:34 South Williamson KY
    static let sample = HumanDesignData(
        type: HDType(
            energyType: "Generator",
            strategy: "Wait to Respond",
            signature: "Satisfaction",
            notSelf: "Frustration",
            aura: "Open & Enveloping"
        ),
        authority: HDAuthority(innerAuthority: "Emotional Authority"),
        profile: HDProfile(
            profile: "4/6: Opportunist Role Model",
            incarnationCross: "Right Angle Cross of Eden (3)"
        ),
        definition: HDDefinition(
            definitionType: "Single Definition",
            definedCenters: ["Sacral", "G_Center", "Spleen", "Solar Plexus"],
            undefinedCenters: ["Heart", "Root", "Throat", "Ajna", "Head"]
        ),
        variables: HDVariables(
            topLeft:     HDVariables.HDVariableArrow(value: "right"),
            bottomLeft:  HDVariables.HDVariableArrow(value: "left"),
            topRight:    HDVariables.HDVariableArrow(value: "left"),
            bottomRight: HDVariables.HDVariableArrow(value: "left")
        ),
        planets: HDPlanets(
            personality: [
                "sun":        HDPlanetData(longitude: 175.607, gate: 6,  line: 4, color: 2, tone: 1, base: 3, channelPartner: 59, dignity: "exalted"),
                "earth":      HDPlanetData(longitude: 355.607, gate: 36, line: 4, color: 2, tone: 1, base: 3, channelPartner: 0,  dignity: nil),
                "moon":       HDPlanetData(longitude: 23.131,  gate: 42, line: 3, color: 4, tone: 2, base: 3, channelPartner: 0,  dignity: "detriment"),
                "north_node": HDPlanetData(longitude: 176.737, gate: 6,  line: 5, color: 3, tone: 2, base: 5, channelPartner: 59, dignity: nil),
                "south_node": HDPlanetData(longitude: 356.737, gate: 36, line: 5, color: 3, tone: 2, base: 5, channelPartner: 0,  dignity: nil),
                "mercury":    HDPlanetData(longitude: 165.572, gate: 64, line: 5, color: 3, tone: 6, base: 1, channelPartner: 0,  dignity: nil),
                "venus":      HDPlanetData(longitude: 219.749, gate: 44, line: 3, color: 2, tone: 4, base: 3, channelPartner: 0,  dignity: nil),
                "mars":       HDPlanetData(longitude: 209.347, gate: 50, line: 4, color: 2, tone: 1, base: 1, channelPartner: 0,  dignity: "detriment"),
                "jupiter":    HDPlanetData(longitude: 122.473, gate: 31, line: 1, color: 4, tone: 1, base: 1, channelPartner: 0,  dignity: nil),
                "saturn":     HDPlanetData(longitude: 156.769, gate: 40, line: 2, color: 1, tone: 4, base: 1, channelPartner: 0,  dignity: nil),
                "uranus":     HDPlanetData(longitude: 223.781, gate: 1,  line: 1, color: 4, tone: 3, base: 2, channelPartner: 0,  dignity: "detriment"),
                "neptune":    HDPlanetData(longitude: 255.676, gate: 5,  line: 5, color: 4, tone: 4, base: 1, channelPartner: 15, dignity: nil),
                "pluto":      HDPlanetData(longitude: 195.768, gate: 57, line: 1, color: 5, tone: 1, base: 4, channelPartner: 34, dignity: "detriment"),
            ],
            design: [
                "sun":        HDPlanetData(longitude: 87.607,  gate: 12, line: 6, color: 2, tone: 6, base: 2, channelPartner: 0,  dignity: "exalted"),
                "earth":      HDPlanetData(longitude: 267.607, gate: 11, line: 6, color: 2, tone: 6, base: 2, channelPartner: 0,  dignity: nil),
                "moon":       HDPlanetData(longitude: 244.903, gate: 34, line: 6, color: 1, tone: 4, base: 3, channelPartner: 57, dignity: nil),
                "north_node": HDPlanetData(longitude: 181.852, gate: 46, line: 4, color: 6, tone: 1, base: 2, channelPartner: 29, dignity: nil),
                "south_node": HDPlanetData(longitude: 1.852,   gate: 25, line: 4, color: 6, tone: 1, base: 2, channelPartner: 0,  dignity: nil),
                "mercury":    HDPlanetData(longitude: 93.433,  gate: 15, line: 6, color: 4, tone: 2, base: 1, channelPartner: 5,  dignity: nil),
                "venus":      HDPlanetData(longitude: 123.514, gate: 31, line: 2, color: 4, tone: 5, base: 1, channelPartner: 0,  dignity: "exalted"),
                "mars":       HDPlanetData(longitude: 152.835, gate: 59, line: 3, color: 6, tone: 3, base: 1, channelPartner: 6,  dignity: "detriment"),
                "jupiter":    HDPlanetData(longitude: 103.075, gate: 39, line: 4, color: 5, tone: 6, base: 2, channelPartner: 0,  dignity: nil),
                "saturn":     HDPlanetData(longitude: 146.143, gate: 29, line: 2, color: 5, tone: 4, base: 1, channelPartner: 46, dignity: nil),
                "uranus":     HDPlanetData(longitude: 222.744, gate: 44, line: 6, color: 3, tone: 5, base: 3, channelPartner: 0,  dignity: nil),
                "neptune":    HDPlanetData(longitude: 256.647, gate: 5,  line: 6, color: 4, tone: 5, base: 3, channelPartner: 15, dignity: "exalted"),
                "pluto":      HDPlanetData(longitude: 193.905, gate: 48, line: 5, color: 5, tone: 2, base: 1, channelPartner: 0,  dignity: nil),
            ]
        ),
        channels: [
            "6/59: The Channel of Mating (A Design Focused on Reproduction)",
            "5/15: The Channel of Rhythm (A Design of Being in the Flow)",
            "34/57: The Channel of Power (A Design of an Archetype)",
            "29/46: The Channel of Discovery (A Design of Succeeding Where Others Fail)"
        ]
    )
}

// MARK: - Xcode Preview

#Preview("HD Bodygraph") {
    BodygraphView(data: BodygraphPreviewData.sample)
        .frame(width: 400, height: 578)
        .background(Color.black)
}
