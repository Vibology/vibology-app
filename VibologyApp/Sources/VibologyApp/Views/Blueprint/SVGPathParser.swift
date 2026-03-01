import SwiftUI
import CoreGraphics

// MARK: - SVG Path Parser
// Parses the subset of SVG path `d` attribute commands used in layout_data.json:
// M m  L l  H h  V v  C c  Z z
// Scientific notation numbers (e.g. -4e-5) are handled correctly.

enum SVGPathParser {

    static func path(from d: String) -> Path {
        var cgPath = CGMutablePath()
        parse(d, into: &cgPath)
        return Path(cgPath)
    }

    // MARK: - Parser

    private static func parse(_ d: String, into cgPath: inout CGMutablePath) {
        let tokens = tokenize(d)
        var i = 0
        var current = CGPoint.zero
        var start   = CGPoint.zero
        var lastCmd: Character = "M"

        func num() -> CGFloat {
            guard i < tokens.count, let v = Double(tokens[i]) else { return 0 }
            i += 1
            return CGFloat(v)
        }

        while i < tokens.count {
            // Advance command letter if present
            if let c = tokens[i].first, c.isLetter, tokens[i].count == 1 {
                lastCmd = c
                i += 1
            }

            switch lastCmd {

            // ── Move ──────────────────────────────────────────────────────────
            case "M":
                let pt = CGPoint(x: num(), y: num())
                cgPath.move(to: pt)
                current = pt; start = pt
                lastCmd = "L"

            case "m":
                let pt = CGPoint(x: current.x + num(), y: current.y + num())
                cgPath.move(to: pt)
                current = pt; start = pt
                lastCmd = "l"

            // ── Line ──────────────────────────────────────────────────────────
            case "L":
                let pt = CGPoint(x: num(), y: num())
                cgPath.addLine(to: pt); current = pt

            case "l":
                let pt = CGPoint(x: current.x + num(), y: current.y + num())
                cgPath.addLine(to: pt); current = pt

            case "H":
                let pt = CGPoint(x: num(), y: current.y)
                cgPath.addLine(to: pt); current = pt

            case "h":
                let pt = CGPoint(x: current.x + num(), y: current.y)
                cgPath.addLine(to: pt); current = pt

            case "V":
                let pt = CGPoint(x: current.x, y: num())
                cgPath.addLine(to: pt); current = pt

            case "v":
                let pt = CGPoint(x: current.x, y: current.y + num())
                cgPath.addLine(to: pt); current = pt

            // ── Cubic Bezier ──────────────────────────────────────────────────
            case "C":
                let c1 = CGPoint(x: num(), y: num())
                let c2 = CGPoint(x: num(), y: num())
                let ep = CGPoint(x: num(), y: num())
                cgPath.addCurve(to: ep, control1: c1, control2: c2)
                current = ep

            case "c":
                let c1 = CGPoint(x: current.x + num(), y: current.y + num())
                let c2 = CGPoint(x: current.x + num(), y: current.y + num())
                let ep = CGPoint(x: current.x + num(), y: current.y + num())
                cgPath.addCurve(to: ep, control1: c1, control2: c2)
                current = ep

            // ── Close ─────────────────────────────────────────────────────────
            case "Z", "z":
                cgPath.closeSubpath()
                current = start

            // ── Arc (approximate as line to endpoint) ─────────────────────────
            case "A":
                let _ = num(); let _ = num(); let _ = num()  // rx ry x-rotation
                let _ = num(); let _ = num()                  // large-arc-flag sweep-flag
                let ep = CGPoint(x: num(), y: num())
                cgPath.addLine(to: ep); current = ep

            case "a":
                let _ = num(); let _ = num(); let _ = num()
                let _ = num(); let _ = num()
                let ep = CGPoint(x: current.x + num(), y: current.y + num())
                cgPath.addLine(to: ep); current = ep

            default:
                i += 1
            }
        }
    }

    // MARK: - Tokenizer
    // Handles: command letters, signed decimals, scientific notation (e.g. -4e-5),
    // comma-or-space separators.

    private static func tokenize(_ d: String) -> [String] {
        var tokens: [String] = []
        let chars = Array(d)
        var i = 0

        while i < chars.count {
            let ch = chars[i]

            // Command letter (not 'e'/'E' which appears in scientific notation)
            if ch.isLetter, ch != "e", ch != "E" {
                tokens.append(String(ch))
                i += 1
                continue
            }

            // Separator
            if ch == "," || ch.isWhitespace {
                i += 1
                continue
            }

            // Number (including leading sign, decimal, scientific notation)
            if ch.isNumber || ch == "." || ch == "-" || ch == "+" {
                var num = ""
                // Leading sign
                if ch == "-" || ch == "+" {
                    num.append(ch); i += 1
                }
                // Integer + decimal part
                while i < chars.count, chars[i].isNumber || chars[i] == "." {
                    num.append(chars[i]); i += 1
                }
                // Scientific notation exponent
                if i < chars.count, chars[i] == "e" || chars[i] == "E" {
                    num.append(chars[i]); i += 1
                    if i < chars.count, chars[i] == "-" || chars[i] == "+" {
                        num.append(chars[i]); i += 1
                    }
                    while i < chars.count, chars[i].isNumber {
                        num.append(chars[i]); i += 1
                    }
                }
                if !num.isEmpty, num != "-", num != "+" {
                    tokens.append(num)
                }
                continue
            }

            i += 1
        }

        return tokens
    }
}
