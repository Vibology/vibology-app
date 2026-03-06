import Foundation
import SwiftUI
import CoreGraphics

// MARK: - BodygraphData
//
// Loads and caches all geometry from bodygraph.svg (2060×2652 canvas space).
// Provides static lookup tables used by BodygraphView for HD data mapping.

struct BodygraphData {

    // MARK: Geometry (2060×2652 coordinate space)

    let bodyOutline:   Path
    let channelPaths:  [String: Path]    // SVG id (e.g. "9-52")        → Path
    let centers:       [String: Path]    // SVG id (e.g. "Root-Center") → Path
    let gatePositions: [Int: CGPoint]    // gate number                 → circle centre

    // MARK: Derived channel lookups (built at load time)

    /// Normalised "minGate-maxGate" key → SVG channel id.
    /// e.g. "6-59" → "59-6",  "9-52" → "9-52"
    let channelBySortedPair: [String: String]

    /// Gate number → all SVG channel ids that contain that gate.
    /// e.g. 20 → ["20-57", "20-10", "20-34"]
    let channelsByGate: [Int: [String]]

    // MARK: - Static mappings

    /// API definedCenters string → SVG group id
    static let apiCenterToSVGID: [String: String] = [
        "Head":         "Head-Center",
        "Ajna":         "Ajna-Center",
        "Throat":       "Throat-Center",
        "G_Center":     "G-Center",
        "Heart":        "HeartEgo-Center",
        "Sacral":       "Sacral-Center",
        "Solar Plexus": "Solar-Plexus-Center",
        "Spleen":       "Spleen-Center",
        "Root":         "Root-Center",
    ]

    /// Centre abbreviation (from gateToCenter) → SVG group id
    static let centerAbbrevToSVGID: [String: String] = [
        "HD": "Head-Center",
        "AA": "Ajna-Center",
        "TT": "Throat-Center",
        "GC": "G-Center",
        "HT": "HeartEgo-Center",
        "SL": "Sacral-Center",
        "SP": "Solar-Plexus-Center",
        "SN": "Spleen-Center",
        "RT": "Root-Center",
    ]

    /// Gate 1–64 → centre abbreviation. Derived from GATES_CHAKRA_DICT in hd_constants.py.
    static let gateToCenter: [Int: String] = [
        // HD (Head)
        64: "HD", 61: "HD", 63: "HD",
        // AA (Ajna)
        47: "AA", 24: "AA",  4: "AA", 17: "AA", 43: "AA", 11: "AA",
        // TT (Throat)
        62: "TT", 23: "TT", 56: "TT", 16: "TT", 20: "TT", 31: "TT",
         8: "TT", 33: "TT", 45: "TT", 35: "TT", 12: "TT",
        // SN (Spleen)
        48: "SN", 57: "SN", 32: "SN", 28: "SN", 18: "SN", 50: "SN", 44: "SN",
        // GC (G-Centre)
        10: "GC",  7: "GC",  1: "GC", 13: "GC",  2: "GC", 46: "GC", 15: "GC", 25: "GC",
        // HT (Heart/Ego)
        21: "HT", 51: "HT", 26: "HT", 40: "HT",
        // SP (Solar Plexus)
        36: "SP", 22: "SP",  6: "SP", 37: "SP", 49: "SP", 55: "SP", 30: "SP",
        // SL (Sacral)
        34: "SL", 27: "SL",  5: "SL", 14: "SL", 29: "SL", 59: "SL",
        42: "SL",  3: "SL",  9: "SL",
        // RT (Root)
        54: "RT", 38: "RT", 58: "RT", 53: "RT", 60: "RT", 52: "RT",
        19: "RT", 39: "RT", 41: "RT",
    ]

    // MARK: - Shared instance

    static let shared: BodygraphData = load()

    // MARK: - Loader

    /// Finds bodygraph.svg across both Xcode app-bundle builds (Bundle.main)
    /// and SPM swift-build outputs (SPM resource sub-bundle next to the executable).
    private static func svgData() -> Data? {
        let name = "bodygraph", ext = "svg"

        // 1. Xcode app build — resources land directly in Bundle.main
        if let url = Bundle.main.url(forResource: name, withExtension: ext),
           let data = try? Data(contentsOf: url) { return data }

        // 2. SPM swift build — resources live in a generated sub-bundle
        let spmBundle = "VibologyApp_VibologyApp"
        for base in [Bundle.main.resourceURL, Bundle.main.bundleURL].compactMap({ $0 }) {
            let bundleURL = base.appendingPathComponent("\(spmBundle).bundle")
            if let b = Bundle(url: bundleURL),
               let url = b.url(forResource: name, withExtension: ext),
               let data = try? Data(contentsOf: url) { return data }
        }

        // 3. Scan all loaded bundles
        for b in Bundle.allBundles + Bundle.allFrameworks {
            if let url = b.url(forResource: name, withExtension: ext),
               let data = try? Data(contentsOf: url) { return data }
        }

        // 4. Development fallback: resolve from this source file's path.
        //    BodygraphLayout.swift lives at Sources/VibologyApp/Views/Blueprint/
        //    Resources/ is at                Sources/VibologyApp/Resources/
        //    Use #filePath (not #file) — in Swift 5.8+ #file returns a short module-
        //    relative path; #filePath always returns the absolute filesystem path.
        let devURL = URL(fileURLWithPath: #filePath)
            .deletingLastPathComponent()   // Blueprint/
            .deletingLastPathComponent()   // Views/
            .deletingLastPathComponent()   // VibologyApp/
            .appendingPathComponent("Resources/\(name).\(ext)")
        if let data = try? Data(contentsOf: devURL) { return data }

        return nil
    }

    private static func load() -> BodygraphData {
        guard let data = svgData() else { fatalError("bodygraph.svg not found in app bundle") }

        let parsed = SVGBodygraphParser.parse(svgData: data)

        // Convert raw path strings → SwiftUI Paths
        let bodyOutline = SVGPathParser.path(from: parsed.bodyD)

        var channelPaths: [String: Path] = [:]
        for (id, d) in parsed.channelDs {
            channelPaths[id] = SVGPathParser.path(from: d)
        }

        var centers: [String: Path] = [:]
        for (id, d) in parsed.centerDs {
            centers[id] = SVGPathParser.path(from: d)
        }

        // Build derived channel lookups
        var channelBySortedPair: [String: String] = [:]
        var channelsByGate: [Int: [String]] = [:]

        for svgID in channelPaths.keys {
            let parts = svgID.split(separator: "-").compactMap { Int($0) }
            guard parts.count == 2 else { continue }
            let key = "\(min(parts[0], parts[1]))-\(max(parts[0], parts[1]))"
            channelBySortedPair[key] = svgID
            channelsByGate[parts[0], default: []].append(svgID)
            channelsByGate[parts[1], default: []].append(svgID)
        }

        return BodygraphData(
            bodyOutline:         bodyOutline,
            channelPaths:        channelPaths,
            centers:             centers,
            gatePositions:       parsed.gatePositions,
            channelBySortedPair: channelBySortedPair,
            channelsByGate:      channelsByGate
        )
    }
}

// MARK: - SVGBodygraphParser
//
// Pure-Swift line scanner for bodygraph.svg (2060×2652 canvas).
// Returns raw SVG path strings and CGPoints — no SwiftUI dependency.
// Relies on Pixelmator Pro's predictable output: one element per line,
// double-quoted attributes, </g> on its own line.

private struct SVGBodygraphParser {

    var bodyD:         String = ""
    var channelDs:     [String: String] = [:]
    var centerDs:      [String: String] = [:]
    var gatePositions: [Int: CGPoint]   = [:]

    static func parse(svgData: Data) -> SVGBodygraphParser {
        guard let svg = String(data: svgData, encoding: .utf8) else {
            return SVGBodygraphParser()
        }
        var p = SVGBodygraphParser()
        p.scan(svg)
        return p
    }

    private mutating func scan(_ svg: String) {
        var groupStack:     [String] = []
        var seenCenterShape = Set<String>()
        let lines = svg.components(separatedBy: "\n")
        var i = 0

        while i < lines.count {
            let line = lines[i].trimmingCharacters(in: .whitespaces)

            if line.hasPrefix("<g ") {
                groupStack.append(attr("id", in: line) ?? "")
            } else if line.hasPrefix("</g>") {
                if !groupStack.isEmpty { groupStack.removeLast() }
            } else if line.hasPrefix("<path ") {
                let id     = attr("id", in: line) ?? ""
                let d      = attr("d",  in: line) ?? ""
                let parent = groupStack.last ?? ""
                guard !d.isEmpty else { i += 1; continue }

                if id == "New-Body" || id == "Body" {
                    bodyD = d
                } else if parent == "Channels", !id.isEmpty {
                    channelDs[id] = d
                } else if Self.centerGroupIDs.contains(parent) {
                    if gateFromActiveID(id) == nil, !seenCenterShape.contains(parent) {
                        centerDs[parent] = d
                        seenCenterShape.insert(parent)
                    } else if let gate = gateFromActiveID(id),
                              let pt = circleCenter(from: d) {
                        gatePositions[gate] = pt
                    }
                }
            } else if line.hasPrefix("<text ") {
                let id = attr("id", in: line) ?? ""
                guard let gate = gateFromTextID(id),
                      gatePositions[gate] == nil else { i += 1; continue }

                if let x = doubleAttr("x", in: line), let y = doubleAttr("y", in: line) {
                    gatePositions[gate] = CGPoint(x: x, y: y)
                } else {
                    i += 1
                    while i < lines.count {
                        let next = lines[i].trimmingCharacters(in: .whitespaces)
                        if next.hasPrefix("<tspan "),
                           let x = doubleAttr("x", in: next),
                           let y = doubleAttr("y", in: next) {
                            gatePositions[gate] = CGPoint(x: x, y: y)
                            break
                        }
                        if next.hasPrefix("</text>") { break }
                        i += 1
                    }
                }
            }
            i += 1
        }
    }

    // Gate-XX-Active circles start at (cx+r, cy); third C endpoint is (cx-r, cy).
    private func circleCenter(from d: String) -> CGPoint? {
        let tokens = d.components(separatedBy: .whitespaces).filter { !$0.isEmpty }
        guard tokens.count >= 3, tokens[0] == "M",
              let mx = Double(tokens[1]), let my = Double(tokens[2]) else { return nil }
        if tokens.count >= 10, tokens[3] == "C", let ex = Double(tokens[8]) {
            // mx = cx+r (rightmost start), ex = cx (top of circle, same x as centre)
            return CGPoint(x: ex, y: my)
        }
        return CGPoint(x: mx, y: my)
    }

    private func attr(_ name: String, in element: String) -> String? {
        // Require a space before the attribute name so `d="` doesn't match
        // inside `id="..."` (where the `d` is the last char of `id`).
        let needle = " \(name)=\""
        guard let r = element.range(of: needle) else { return nil }
        let start = r.upperBound
        guard let end = element[start...].firstIndex(of: "\"") else { return nil }
        return String(element[start..<end])
    }

    private func doubleAttr(_ name: String, in element: String) -> Double? {
        attr(name, in: element).flatMap(Double.init)
    }

    private static let centerGroupIDs: Set<String> = [
        "Root-Center", "Spleen-Center", "Solar-Plexus-Center",
        "Sacral-Center", "HeartEgo-Center", "G-Center",
        "Throat-Center", "Ajna-Center", "Head-Center",
    ]

    private func gateFromActiveID(_ id: String) -> Int? {
        guard id.hasPrefix("Gate-"), id.hasSuffix("-Active") else { return nil }
        return Int(id.dropFirst(5).dropLast(7))
    }

    private func gateFromTextID(_ id: String) -> Int? {
        guard id.hasPrefix("Gate-"), !id.hasSuffix("-Active") else { return nil }
        return Int(id.dropFirst(5))
    }
}
