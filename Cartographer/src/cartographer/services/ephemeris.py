"""
Skyfield ephemeris wrapper — central module for all astronomical calculations.

All other modules should import from here rather than using pyswisseph directly.
Ephemeris file: de440s.bsp (JPL DE440 small, covers 1849–2150, ~32 MB, public domain).
"""

import os
import math
import logging
from functools import lru_cache

from skyfield.api import Loader, Timescale
from skyfield.framelib import ecliptic_frame

logger = logging.getLogger(__name__)

# ─── Ephemeris loading ────────────────────────────────────────────────────────

_EPHEMERIS_PATH = os.environ.get("SKYFIELD_EPHEMERIS_PATH", "/data/ephemeris")
_eph = None
_ts: Timescale = None


def _ensure_loaded():
    global _eph, _ts
    if _eph is None:
        load = Loader(_EPHEMERIS_PATH)
        _eph = load("de440s.bsp")
        _ts = load.timescale()
        logger.info("Skyfield de440s.bsp ephemeris loaded from %s", _EPHEMERIS_PATH)


def load_ephemeris():
    """Load and return the de440s ephemeris (cached at module level)."""
    _ensure_loaded()
    return _eph


def get_timescale() -> Timescale:
    """Return the shared Skyfield Timescale object."""
    _ensure_loaded()
    return _ts


# ─── Time conversion helpers ─────────────────────────────────────────────────

def birth_to_time(year: int, month: int, day: int,
                  hour: int, minute: int, second: int,
                  tz_offset_hours: float):
    """
    Convert a local birth datetime + UTC offset to a Skyfield Time object.

    tz_offset_hours: e.g. -5.0 for EST, +1.0 for CET.
    """
    _ensure_loaded()
    # Convert to UTC
    total_seconds_offset = tz_offset_hours * 3600
    from datetime import datetime, timezone, timedelta
    local_dt = datetime(year, month, day, hour, minute, int(second))
    utc_dt = local_dt - timedelta(seconds=total_seconds_offset)
    return _ts.utc(utc_dt.year, utc_dt.month, utc_dt.day,
                   utc_dt.hour, utc_dt.minute, utc_dt.second)


def jd_to_time(jd: float):
    """Convert a Julian Day number (UT1) to a Skyfield Time object."""
    _ensure_loaded()
    return _ts.tt_jd(jd)


def time_to_jd(t) -> float:
    """Return the Terrestrial Time Julian Day for a Skyfield Time object."""
    return t.tt


def time_to_utc_tuple(t) -> tuple:
    """
    Return (year, month, day, hour, minute, second) in UTC.
    Replaces swe.jdut1_to_utc().
    """
    y, mo, d, h, mi, s = t.utc
    return (int(y), int(mo), int(d), int(h), int(mi), float(s))


# ─── Planet body lookup ───────────────────────────────────────────────────────

def _earth_body():
    _ensure_loaded()
    return _eph["earth"]


def _get_body(planet_key: str):
    """
    Return the Skyfield body for a given planet name string.

    Returns None for Earth, North_Node, South_Node — those are handled separately.
    """
    _ensure_loaded()
    mapping = {
        "Sun": "sun",
        "Moon": "moon",
        "Mercury": "mercury",
        "Venus": "venus",
        "Mars": "mars barycenter",
        "Jupiter": "jupiter barycenter",
        "Saturn": "saturn barycenter",
        "Uranus": "uranus barycenter",
        "Neptune": "neptune barycenter",
        "Pluto": "pluto barycenter",
        # Chiron is not in DE440s — return None so caller can skip
        "Chiron": None,
    }
    return mapping.get(planet_key)


# ─── Ecliptic longitude ───────────────────────────────────────────────────────

def mean_north_node(t) -> float:
    """
    IAU formula for mean lunar north node longitude (degrees 0–360).
    Replaces pyswisseph's node calculation.
    """
    T = (t.tt - 2451545.0) / 36525.0
    omega = (125.04452
             - 1934.136261 * T
             + 0.0020708 * T ** 2
             + T ** 3 / 450000.0)
    return omega % 360


def get_ecliptic_longitude(t, planet_key: str) -> float:
    """
    Return ecliptic longitude (0–360°) for the named planet at time t.

    Handles Earth (Sun + 180°), North_Node, South_Node, Chiron (returns NaN).
    Replaces swe.calc_ut().
    """
    _ensure_loaded()

    if planet_key == "Earth":
        sun_lon = get_ecliptic_longitude(t, "Sun")
        return (sun_lon + 180.0) % 360.0

    if planet_key == "North_Node":
        return mean_north_node(t)

    if planet_key == "South_Node":
        return (mean_north_node(t) + 180.0) % 360.0

    if planet_key == "Chiron":
        return float("nan")

    body_key = _get_body(planet_key)
    if body_key is None:
        return float("nan")

    earth = _earth_body()
    body = _eph[body_key]
    astrometric = earth.at(t).observe(body)
    _, lon, _ = astrometric.apparent().frame_latlon(ecliptic_frame)
    return float(lon.degrees) % 360.0


def get_planet_speed(t, planet_key: str) -> float:
    """
    Return the ecliptic longitude speed (degrees/day) for the named planet.

    Negative value means retrograde motion.
    Skips Earth, nodes, Chiron (returns 0.0).
    """
    _ensure_loaded()
    if planet_key in ("Earth", "North_Node", "South_Node", "Chiron"):
        return 0.0

    body_key = _get_body(planet_key)
    if body_key is None:
        return 0.0

    # Finite difference: step half a day forward and backward
    dt = 0.5  # days
    t0 = _ts.tt_jd(t.tt - dt)
    t1 = _ts.tt_jd(t.tt + dt)

    lon0 = get_ecliptic_longitude(t0, planet_key)
    lon1 = get_ecliptic_longitude(t1, planet_key)

    # Handle 0°/360° wrap
    diff = (lon1 - lon0 + 180.0) % 360.0 - 180.0
    return float(diff / (2.0 * dt))


def get_obliquity(t) -> float:
    """
    Return the mean obliquity of the ecliptic in degrees at time t.
    IAU 2006 formula (good to ~0.001° over centuries).
    """
    T = (t.tt - 2451545.0) / 36525.0
    eps = (84381.406
           - 46.836769 * T
           - 0.0001831 * T ** 2
           + 0.00200340 * T ** 3) / 3600.0
    return eps


# ─── Solar crossing (binary search) ─────────────────────────────────────────

def find_sun_crossing(target_lon: float, t_start, t_end):
    """
    Find the moment when the Sun's ecliptic longitude crosses target_lon.

    Uses binary search (50 iterations ≈ nanosecond precision).
    Replaces swe.solcross_ut().

    Args:
        target_lon: target ecliptic longitude in degrees (0–360)
        t_start: Skyfield Time — search start
        t_end: Skyfield Time — search end

    Returns:
        Skyfield Time of crossing
    """
    _ensure_loaded()
    jd0 = t_start.tt
    jd1 = t_end.tt

    for _ in range(50):
        jd_mid = (jd0 + jd1) / 2.0
        t_mid = _ts.tt_jd(jd_mid)
        sun_lon = get_ecliptic_longitude(t_mid, "Sun")
        dist = (sun_lon - target_lon + 180.0) % 360.0 - 180.0
        if dist > 0:
            jd1 = jd_mid
        else:
            jd0 = jd_mid

    return _ts.tt_jd((jd0 + jd1) / 2.0)


# ─── House cusps (Placidus) ───────────────────────────────────────────────────

def calculate_placidus_cusps(t, lat: float, lon: float) -> list:
    """
    Calculate Placidus house cusps for a given time and geographic location.

    Args:
        t: Skyfield Time
        lat: geographic latitude in degrees (north positive)
        lon: geographic longitude in degrees (east positive)

    Returns:
        List of 12 house cusp longitudes (degrees 0–360), houses 1–12.
    """
    obliquity = get_obliquity(t)
    eps = math.radians(obliquity)

    # GAST in degrees → RAMC
    gast_deg = t.gast * 15.0  # gast is in hours
    ramc = math.radians((gast_deg + lon) % 360.0)

    lat_r = math.radians(lat)

    # MC (Medium Coeli)
    mc_rad = math.atan2(math.tan(ramc), math.cos(eps))
    if mc_rad < 0:
        mc_rad += math.pi
    if math.cos(ramc) < 0:
        mc_rad += math.pi
    mc = math.degrees(mc_rad) % 360.0

    # ASC (Ascendant)
    asc_rad = math.atan2(
        math.cos(ramc),
        -(math.sin(eps) * math.tan(lat_r) + math.cos(eps) * math.sin(ramc))
    )
    asc = math.degrees(asc_rad) % 360.0
    # Ensure ASC is in the upper hemisphere (below the horizon)
    if asc < mc:
        asc += 180.0
    asc = asc % 360.0

    # Placidus intermediate houses via semi-arc trisection
    def placidus_cusp(house_fraction: float, diurnal: bool) -> float:
        """
        house_fraction: 1/3 or 2/3 of the appropriate semi-arc
        diurnal: True for houses 10–11 side (upper), False for lower
        """
        # Iterative solution — converges in ~10 iterations
        cusp = mc + house_fraction * 90.0  # initial estimate
        for _ in range(20):
            cusp_r = math.radians(cusp)
            # Declination of point on ecliptic at cusp longitude
            sin_dec = math.sin(eps) * math.sin(cusp_r)
            dec = math.asin(max(-1.0, min(1.0, sin_dec)))
            # Semi-arc
            cos_sa = -math.tan(lat_r) * math.tan(dec)
            cos_sa = max(-1.0, min(1.0, cos_sa))
            sa = math.acos(cos_sa)  # radians; diurnal semi-arc
            if not diurnal:
                sa = math.pi - sa
            # RAMC of cusp
            ramc_cusp = math.radians(ramc) * (180.0 / math.pi) + math.degrees(sa) * house_fraction
            # Cusp longitude from RAMC
            new_cusp_r = math.atan2(
                math.cos(math.radians(ramc_cusp)),
                -(math.sin(eps) * math.tan(lat_r) + math.cos(eps) * math.sin(math.radians(ramc_cusp)))
            )
            new_cusp = math.degrees(new_cusp_r) % 360.0
            if abs(new_cusp - cusp) < 0.0001:
                break
            cusp = new_cusp
        return cusp % 360.0

    # Standard Placidus: houses 11, 12 are 1/3 and 2/3 of diurnal semi-arc from MC
    # Houses 2, 3 are 1/3 and 2/3 of nocturnal semi-arc from IC
    # We use the Ascendant and MC as anchors for houses 1 and 10 respectively.
    ic = (mc + 180.0) % 360.0
    dsc = (asc + 180.0) % 360.0

    # Houses 11, 12 (upper): trisect arc from MC→ASC (going forward)
    h11 = placidus_cusp(1.0 / 3.0, diurnal=True)
    h12 = placidus_cusp(2.0 / 3.0, diurnal=True)

    # Houses 2, 3 (lower): trisect arc from IC→DSC
    h2 = placidus_cusp(1.0 / 3.0, diurnal=False)
    h3 = placidus_cusp(2.0 / 3.0, diurnal=False)

    # Build all 12 cusps
    cusps = [
        asc,          # 1
        h2,           # 2
        h3,           # 3
        ic,           # 4
        (h11 + 180.0) % 360.0,  # 5 = opposite of 11
        (h12 + 180.0) % 360.0,  # 6 = opposite of 12
        dsc,          # 7 = opposite of ASC
        (h2 + 180.0) % 360.0,   # 8 = opposite of 2
        (h3 + 180.0) % 360.0,   # 9 = opposite of 3
        mc,           # 10
        h11,          # 11
        h12,          # 12
    ]

    return cusps
