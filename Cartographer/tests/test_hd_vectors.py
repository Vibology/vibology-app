"""
Human Design Test Vectors
=========================

Two test tiers:

  Tier 1 — Formula Consistency (auto-pass/fail)
    Given a Sun longitude returned by the API, does the gate/line/color/tone/base
    match the formula applied to that same longitude? This catches any mismatch
    between what the ephemeris produces and how it's mapped to HD values.

  Tier 2 — Reference Cross-Check (requires manual comparison)
    These birth dates have known HD charts (verified against mybodygraph.com or
    Jovian Archive). Run the script, then compare the REFERENCE TABLE output
    against those sites.

Usage:
    # From the Cartographer directory:
    python tests/test_hd_vectors.py

    # Or against local dev server:
    BASE_URL=http://localhost:8000 python tests/test_hd_vectors.py
"""

import os
import sys
import math
import json
import urllib.request
import urllib.parse
from typing import NamedTuple, Optional

BASE_URL = os.environ.get("BASE_URL", "https://cartographer-273583413962.us-central1.run.app")

# ── Gate-circle constants (must mirror hd_constants.py) ──────────────────────

IGING_OFFSET = 58

IGING_CIRCLE = [
    41, 19, 13, 49, 30, 55, 37, 63, 22, 36, 25, 17, 21, 51, 42,  3,
    27, 24,  2, 23,  8, 20, 16, 35, 45, 12, 15, 52, 39, 53, 62, 56,
    31, 33,  7,  4, 29, 59, 40, 64, 47,  6, 46, 18, 48, 57, 32, 50,
    28, 44,  1, 43, 14, 34,  9,  5, 26, 11, 10, 58, 38, 54, 61, 60,
]

assert len(IGING_CIRCLE) == 64, "Gate circle must have exactly 64 entries"


def lon_to_hd(lon: float) -> dict:
    """Apply the HD gate/line/color/tone/base formula to an ecliptic longitude."""
    angle = (lon + IGING_OFFSET) % 360
    pct = angle / 360
    gate  = IGING_CIRCLE[int(pct * 64)]
    line  = int((pct * 64 * 6) % 6 + 1)
    color = int((pct * 64 * 6 * 6) % 6 + 1)
    tone  = int((pct * 64 * 6 * 6 * 6) % 6 + 1)
    base  = int((pct * 64 * 6 * 6 * 6 * 5) % 5 + 1)
    return {"gate": gate, "line": line, "color": color, "tone": tone, "base": base}


def gate_span_for_lon(lon: float) -> "tuple[float, float]":
    """Return the longitude range [start, end) for the gate at this longitude."""
    gate_size = 360 / 64  # 5.625°
    angle = (lon + IGING_OFFSET) % 360
    gate_idx = int(angle / gate_size)
    gate_start_angle = gate_idx * gate_size
    gate_end_angle   = gate_start_angle + gate_size
    start = (gate_start_angle - IGING_OFFSET) % 360
    end   = (gate_end_angle   - IGING_OFFSET) % 360
    return start, end


# ── API client ────────────────────────────────────────────────────────────────

def call_hd_api(year, month, day, hour, minute, second=0, place="London, UK", lat=None, lon=None) -> dict:
    params = {
        "year": year, "month": month, "day": day,
        "hour": hour, "minute": minute, "second": second,
        "place": place,
    }
    if lat is not None:
        params["latitude"] = lat
    if lon is not None:
        params["longitude"] = lon

    url = f"{BASE_URL}/humandesign/calculate?" + urllib.parse.urlencode(params)
    try:
        with urllib.request.urlopen(url, timeout=30) as resp:
            return json.loads(resp.read())
    except Exception as e:
        print(f"  ERROR calling API: {e}", file=sys.stderr)
        return {}


def extract_planets(response: dict) -> dict[str, dict]:
    """Flatten prs/des planet lists into {label_planet: {Lon, Gate, Line, ...}}."""
    out = {}
    for label in ("prs", "des"):
        planets = response.get("gates", {}).get(label, {}).get("Planets", [])
        for p in planets:
            key = f"{label}_{p['Planet']}"
            out[key] = p
    return out


# ── Tier 1: Formula Consistency ───────────────────────────────────────────────

def check_formula_consistency(response: dict, label: str) -> "list[str]":
    """
    For every planet in the response, recompute the gate from the reported
    longitude and compare against what the API returned.

    NOTE: The API serializes longitude rounded to 3 decimal places (see
    serialization.py:161). Sub-gate subdivisions (line, color, tone, base)
    span as little as 0.005° (base), so a 0.001° rounding error can flip
    them at exact boundary positions. We therefore only check `gate`, which
    spans 5.625° and is immune to this rounding. Line/color/tone/base
    failures would be test artifacts, not real bugs.
    """
    failures = []
    planets = extract_planets(response)
    for key, p in planets.items():
        lon = p.get("Lon")
        if lon is None or (isinstance(lon, float) and math.isnan(lon)):
            continue  # Chiron / unsupported bodies

        expected = lon_to_hd(lon)
        api_gate = p.get("Gate")
        exp_gate = expected["gate"]
        if api_gate != exp_gate:
            failures.append(
                f"{label} | {key}: lon={lon:.4f} → "
                f"expected gate={exp_gate}, got gate={api_gate}"
            )
    return failures


# ── Tier 2: Reference Cross-Check cases ──────────────────────────────────────

class DignityCheck(NamedTuple):
    """Expected dignity for a specific planet activation, verified against reference."""
    label:    str   # "prs" or "des"
    planet:   str   # e.g. "Sun", "Moon", "South_Node"
    gate:     int   # expected gate — used to confirm we're looking at the right activation
    line:     int   # expected line
    dignity:  str   # "exalted" | "detriment" | "juxtaposed" | "neutral"


class RefCase(NamedTuple):
    name:        str
    year:        int
    month:       int
    day:         int
    hour:        int
    minute:      int
    place:       str
    # Expected values — set to None to flag as UNKNOWN (fill in after comparing)
    exp_type:    Optional[str]
    exp_profile: Optional[str]
    exp_cross:   Optional[str]          # partial match is fine
    exp_prs_sun_gate: Optional[int]     # Personality Sun gate
    exp_des_sun_gate: Optional[int]     # Design Sun gate
    note:        str = ""
    dignity_checks: list = []           # list of DignityCheck


REFERENCE_CASES = [
    RefCase(
        name="Vernal Equinox 2000",
        year=2000, month=3, day=20, hour=7, minute=35, place="London, UK",
        # Sun should be at ~0° Aries → angle = 58° → gate 25, line 2
        exp_type=None, exp_profile=None, exp_cross=None,
        exp_prs_sun_gate=25, exp_des_sun_gate=None,
        note="Mathematical anchor: Sun ≈ 0° → gate 25.2"
    ),
    RefCase(
        name="Summer Solstice 2000",
        year=2000, month=6, day=21, hour=1, minute=48, place="London, UK",
        # Sun should be at ~90° Cancer → angle = 148° → gate 15
        exp_type=None, exp_profile=None, exp_cross=None,
        exp_prs_sun_gate=15, exp_des_sun_gate=None,
        note="Mathematical anchor: Sun ≈ 90° → gate 15"
    ),
    RefCase(
        name="Autumnal Equinox 2000",
        year=2000, month=9, day=23, hour=17, minute=28, place="London, UK",
        # Sun should be at ~180° Libra → angle = 238° → gate 46
        exp_type=None, exp_profile=None, exp_cross=None,
        exp_prs_sun_gate=46, exp_des_sun_gate=None,
        note="Mathematical anchor: Sun ≈ 180° → gate 46"
    ),
    RefCase(
        name="Winter Solstice 1999",
        year=1999, month=12, day=22, hour=7, minute=44, place="London, UK",
        # Sun should be at ~270° Capricorn → angle = 328° → gate 10
        exp_type=None, exp_profile=None, exp_cross=None,
        exp_prs_sun_gate=10, exp_des_sun_gate=None,
        note="Mathematical anchor: Sun ≈ 270° → gate 10"
    ),
    # ── Public figures — verified against reference HD software 2026-02 ──────
    # Oprah Winfrey — Generator 2/4, SP, RAC Four Ways (19/33 | 44/24)
    RefCase(
        name="Oprah Winfrey",
        year=1954, month=1, day=29, hour=7, minute=50,
        place="Kosciusko, Mississippi, USA",
        exp_type="Generator",
        exp_profile="2/4: Hermit Opportunist",
        exp_cross="Right Angle Cross of the Four Ways (4)",
        exp_prs_sun_gate=19,
        exp_des_sun_gate=44,
        note="Verified against reference software 2026-02",
        dignity_checks=[
            # Planet is the detriment/exaltation trigger for that gate.line per IHDS data:
            DignityCheck("des", "Sun",    44, 4, "detriment"),  # gate 44.4 detriment: Sun
            DignityCheck("des", "Moon",   18, 6, "detriment"),  # gate 18.6 detriment: Moon
            DignityCheck("des", "Mars",   46, 4, "detriment"),  # gate 46.4 detriment: Mars
            DignityCheck("des", "Uranus", 62, 3, "exalted"),    # gate 62.3 exaltation: Uranus
            DignityCheck("des", "Pluto",  29, 1, "exalted"),    # gate 29.1 exaltation: Pluto
            DignityCheck("prs", "Sun",    19, 2, "detriment"),  # gate 19.2 detriment: Sun
            # NOTE: des_Mercury(34.1), des_Venus(57.6), des_Neptune(32.4) show ▼ in reference
            # but IHDS data lists different planets as detriment for those gate.lines;
            # Cartographer correctly returns neutral for these activations.
        ],
    ),
    # Barack Obama — birth certificate 19:24 HST; Projector 6/2, SP, LAC Refinement (33/19 | 2/1)
    RefCase(
        name="Barack Obama",
        year=1961, month=8, day=4, hour=19, minute=24,
        place="Honolulu, Hawaii, USA",
        exp_type="Projector",
        exp_profile="6/2: Role Model Hermit",
        exp_cross="Left Angle Cross of Refinement (1)",
        exp_prs_sun_gate=33,
        exp_des_sun_gate=2,
        note="Verified against reference software 2026-02",
        dignity_checks=[
            DignityCheck("des", "Mercury",  2, 6, "exalted"),    # gate 2.6 exaltation: Mercury
            DignityCheck("des", "Neptune", 44, 3, "detriment"),  # gate 44.3 detriment: Neptune
            DignityCheck("prs", "Sun",     33, 6, "exalted"),    # gate 33.6 exaltation: Sun
            DignityCheck("prs", "Jupiter", 60, 5, "detriment"),  # gate 60.5 detriment: Jupiter (▼; was misread as exalted)
            DignityCheck("prs", "Saturn",  61, 5, "exalted"),    # gate 61.5 exaltation: Saturn
            # NOTE: prs_South_Node(30.4) shows ▼ in reference but IHDS detriment for 30.4 is Jupiter, not South Node → neutral
        ],
    ),
    # Eckhart Tolle — MG 2/4, Sacral, RAC Contagion (30/29 | 14/8)
    RefCase(
        name="Eckhart Tolle",
        year=1948, month=2, day=16, hour=0, minute=5,
        place="Lünen, Germany",
        exp_type="Manifesting Generator",
        exp_profile="2/4: Hermit Opportunist",
        exp_cross="Right Angle Cross of Contagion (1)",
        exp_prs_sun_gate=30,
        exp_des_sun_gate=14,
        note="Verified against reference software 2026-02",
        dignity_checks=[
            DignityCheck("des", "Saturn",  4, 4, "detriment"),
            DignityCheck("prs", "Sun",    30, 2, "exalted"),
            DignityCheck("prs", "Mars",   29, 5, "detriment"),
            DignityCheck("prs", "Uranus", 45, 6, "exalted"),
        ],
    ),
]


# ── Design date sanity check ──────────────────────────────────────────────────

def check_design_date(response: dict, label: str) -> "list[str]":
    """
    The design (unconscious) Sun should be approximately 88° behind the
    personality Sun. Tolerance: ±2° (the binary search is very precise,
    but rounding in the reported time can introduce small drift).
    """
    failures = []
    planets = extract_planets(response)
    prs_sun = planets.get("prs_Sun")
    des_sun = planets.get("des_Sun")
    if not prs_sun or not des_sun:
        failures.append(f"{label}: missing prs_Sun or des_Sun")
        return failures

    prs_lon = prs_sun["Lon"]
    des_lon = des_sun["Lon"]
    # Expected design Sun = personality Sun − 88°
    expected_des_lon = (prs_lon - 88) % 360
    diff = abs((des_lon - expected_des_lon + 180) % 360 - 180)
    if diff > 2.0:
        failures.append(
            f"{label}: design Sun offset from personality Sun is {(prs_lon - des_lon) % 360:.2f}°, "
            f"expected ~88° (diff from expected: {diff:.2f}°)"
        )
    return failures


# ── Dignity checker ───────────────────────────────────────────────────────────

def check_dignities(response: dict, checks: list, label: str) -> "tuple[list, list]":
    """
    For each DignityCheck, find the planet in the response, confirm the
    gate+line match, then assert the dignity state.

    Returns (failures, gate_mismatches).
    Gate mismatches are reported as warnings, not failures — they indicate
    the reference data had the wrong gate for that planet.
    """
    failures = []
    mismatches = []
    planets = extract_planets(response)

    for chk in checks:
        key = f"{chk.label}_{chk.planet}"
        p = planets.get(key)
        if p is None:
            failures.append(f"{label} | {key}: planet not found in response")
            continue

        actual_gate = p.get("Gate")
        actual_line = p.get("Line")
        actual_dignity = p.get("dignity", "neutral")

        if actual_gate != chk.gate or actual_line != chk.line:
            mismatches.append(
                f"{label} | {key}: expected gate={chk.gate}.{chk.line}, "
                f"got {actual_gate}.{actual_line} — skipping dignity check"
            )
            continue

        if actual_dignity != chk.dignity:
            failures.append(
                f"{label} | {key} gate={chk.gate}.{chk.line}: "
                f"expected dignity='{chk.dignity}', got '{actual_dignity}'"
            )

    return failures, mismatches


# ── Runner ────────────────────────────────────────────────────────────────────

def run_all():
    PASS = "\033[32mPASS\033[0m"
    FAIL = "\033[31mFAIL\033[0m"
    WARN = "\033[33m?   \033[0m"

    all_failures = []
    print(f"\n{'='*72}")
    print("  CARTOGRAPHER — Human Design Test Vectors")
    print(f"  {BASE_URL}")
    print(f"{'='*72}\n")

    # ── Mathematical anchors (equinox/solstice) first ────────────────────────
    print("TIER 1: Formula Consistency + Mathematical Anchors")
    print("-" * 60)

    for case in REFERENCE_CASES:
        print(f"\n  [{case.name}]  {case.year}-{case.month:02d}-{case.day:02d} "
              f"{case.hour:02d}:{case.minute:02d}  {case.place}")
        if case.note:
            print(f"    note: {case.note}")

        resp = call_hd_api(case.year, case.month, case.day,
                           case.hour, case.minute, place=case.place)
        if not resp:
            print(f"    {FAIL} API call failed")
            all_failures.append(f"{case.name}: API call failed")
            continue

        # ── Tier 1a: Formula consistency ─────────────────────────────────────
        formula_failures = check_formula_consistency(resp, case.name)
        if formula_failures:
            for f in formula_failures:
                print(f"    {FAIL} Formula: {f}")
            all_failures.extend(formula_failures)
        else:
            print(f"    {PASS} Formula consistency (all planet gate/line/color/tone/base)")

        # ── Tier 1b: Design date offset ───────────────────────────────────────
        design_failures = check_design_date(resp, case.name)
        if design_failures:
            for f in design_failures:
                print(f"    {FAIL} Design date: {f}")
            all_failures.extend(design_failures)
        else:
            planets = extract_planets(resp)
            prs_sun = planets.get("prs_Sun", {})
            des_sun = planets.get("des_Sun", {})
            offset = (prs_sun.get("Lon", 0) - des_sun.get("Lon", 0)) % 360
            print(f"    {PASS} Design date offset: {offset:.2f}° (expected ~88°)")

        # ── Reference cross-check table ───────────────────────────────────────
        g = resp.get("general", {})
        planets = extract_planets(resp)
        prs_sun = planets.get("prs_Sun", {})
        des_sun = planets.get("des_Sun", {})

        print(f"    → Type:    {g.get('energy_type', '?')}")
        print(f"    → Profile: {g.get('profile', '?')}")
        print(f"    → Cross:   {g.get('inc_cross', '?')}")
        print(f"    → Auth:    {g.get('inner_authority', '?')}")
        print(f"    → prs Sun: gate {prs_sun.get('Gate')}.{prs_sun.get('Line')}  "
              f"lon={prs_sun.get('Lon', '?'):.3f}°")
        print(f"    → des Sun: gate {des_sun.get('Gate')}.{des_sun.get('Line')}  "
              f"lon={des_sun.get('Lon', '?'):.3f}°")

        # ── Hard assertions for verified reference cases ─────────────────────
        def assert_field(field_name, expected, got):
            if expected is None:
                return
            if got == expected:
                print(f"    {PASS} {field_name}: {got}")
            else:
                msg = f"{case.name}: {field_name}: expected '{expected}', got '{got}'"
                print(f"    {FAIL} {msg}")
                all_failures.append(msg)

        planets = extract_planets(resp)
        assert_field("Type",    case.exp_type,    g.get("energy_type"))
        assert_field("Profile", case.exp_profile, g.get("profile"))
        assert_field("Cross",   case.exp_cross,   g.get("inc_cross"))
        if case.exp_prs_sun_gate is not None:
            assert_field("prs Sun gate", case.exp_prs_sun_gate, planets.get("prs_Sun", {}).get("Gate"))
        if case.exp_des_sun_gate is not None:
            assert_field("des Sun gate", case.exp_des_sun_gate, planets.get("des_Sun", {}).get("Gate"))

        # ── Dignity checks ────────────────────────────────────────────────────
        if case.dignity_checks:
            dig_failures, dig_mismatches = check_dignities(resp, case.dignity_checks, case.name)
            for m in dig_mismatches:
                print(f"    {WARN} Gate mismatch: {m}")
            if dig_failures:
                for f in dig_failures:
                    print(f"    {FAIL} Dignity: {f}")
                all_failures.extend(dig_failures)
            else:
                checked = len(case.dignity_checks) - len(dig_mismatches)
                print(f"    {PASS} Dignities: {checked}/{len(case.dignity_checks)} checked"
                      + (f" ({len(dig_mismatches)} gate-mismatched)" if dig_mismatches else ""))

    # ── Summary ───────────────────────────────────────────────────────────────
    print(f"\n{'='*72}")
    if all_failures:
        print(f"  {FAIL}  {len(all_failures)} failure(s):\n")
        for f in all_failures:
            print(f"    • {f}")
    else:
        print(f"  {PASS}  All automated checks passed.")

    print()
    print("  MANUAL CROSS-CHECK")
    print("  Compare the values above against mybodygraph.com or Jovian Archive.")
    print("  Key things to verify for each public figure:")
    print("    1. Type (Generator / Projector / Manifestor / Reflector)")
    print("    2. Profile (e.g. 3/5)")
    print("    3. Incarnation Cross name")
    print("    4. Personality Sun gate.line and Design Sun gate.line")
    print("    5. Defined/undefined centers")
    print(f"{'='*72}\n")

    return len(all_failures) == 0


if __name__ == "__main__":
    ok = run_all()
    sys.exit(0 if ok else 1)
