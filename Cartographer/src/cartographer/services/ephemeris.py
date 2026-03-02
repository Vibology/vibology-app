"""
pyswisseph ephemeris wrapper — central module for all astronomical calculations.

All other modules should import from here rather than using swisseph directly.
Ephemeris files: sepl/semo_18-21.se1 (planets + Moon, 1800–2200) + seas_18-21.se1 (Chiron).
"""

import os
import logging
from datetime import datetime, timedelta

import swisseph as swe

logger = logging.getLogger(__name__)

# ─── Ephemeris path setup ─────────────────────────────────────────────────────

_EPHE_PATH = os.environ.get("SE_EPHE_PATH", "/data/ephe")
swe.set_ephe_path(_EPHE_PATH)
logger.info("Swiss Ephemeris path set to %s", _EPHE_PATH)

# ─── Planet ID map ────────────────────────────────────────────────────────────

BODY_IDS: dict[str, int] = {
    "Sun":        swe.SUN,
    "Moon":       swe.MOON,
    "Mercury":    swe.MERCURY,
    "Venus":      swe.VENUS,
    "Mars":       swe.MARS,
    "Jupiter":    swe.JUPITER,
    "Saturn":     swe.SATURN,
    "Uranus":     swe.URANUS,
    "Neptune":    swe.NEPTUNE,
    "Pluto":      swe.PLUTO,
    "North_Node": swe.MEAN_NODE,
    "South_Node": swe.MEAN_NODE,   # longitude + 180°
    "Chiron":     swe.CHIRON,      # asteroid 2060; requires seas_NN.se1
    "Lilith":     swe.MEAN_APOG,   # Black Moon Lilith (mean lunar apogee)
    # HD gate calculations also call "Earth" — treat as Sun + 180°
    "Earth":      swe.SUN,
}

# Auto-select ephemeris: SE files if valid, Moshier built-in otherwise.
# Do NOT use FLG_SWIEPH — that forces file-only and fails if a file is absent
# or damaged. FLG_SPEED always included so we get longitude velocity in xx[3].
_SWE_FLAGS = swe.FLG_SPEED


# ─── Time conversion ──────────────────────────────────────────────────────────

def local_to_jd(year: int, month: int, day: int,
                hour: int, minute: int, second: int,
                tz_offset_hours: float) -> float:
    """Convert local birth datetime + UTC offset → Julian Day (UT)."""
    local_dt = datetime(year, month, day, hour, minute, int(second))
    utc_dt = local_dt - timedelta(hours=tz_offset_hours)
    ut_hour = utc_dt.hour + utc_dt.minute / 60.0 + utc_dt.second / 3600.0
    return swe.julday(utc_dt.year, utc_dt.month, utc_dt.day, ut_hour)


# ── Backwards-compatible aliases (time ≡ JD float in this implementation) ────

def birth_to_time(year: int, month: int, day: int,
                  hour: int, minute: int, second: int,
                  tz_offset_hours: float) -> float:
    """Alias for local_to_jd(). Returns a JD float."""
    return local_to_jd(year, month, day, hour, minute, int(second), tz_offset_hours)


def jd_to_time(jd: float) -> float:
    """Identity — JD float IS the time type in this implementation."""
    return jd


def time_to_jd(t: float) -> float:
    """Identity — JD float IS the time type in this implementation."""
    return t


def time_to_utc_tuple(t: float) -> tuple:
    """Convert JD (UT) → (year, month, day, hour, minute, second) in UTC."""
    year, month, day, hour, minute, second = swe.jdut1_to_utc(t, swe.GREG_CAL)
    return (int(year), int(month), int(day), int(hour), int(minute), float(second))


class _TimescaleShim:
    """
    Minimal Timescale-like object so features/core.py can call
    get_timescale().utc(year, month, day) without modification.
    """

    def utc(self, year, month=1, day=1, hour=0, minute=0, second=0) -> float:
        """Return JD (UT) for the given UTC date/time."""
        ut_hour = float(hour) + float(minute) / 60.0 + float(second) / 3600.0
        return swe.julday(year, month, day, ut_hour)

    def tt_jd(self, jd: float) -> float:
        """Identity — no TT/UT distinction needed at this precision."""
        return jd


def get_timescale() -> _TimescaleShim:
    """Return a timescale-like shim for backwards compatibility with features/core.py."""
    return _TimescaleShim()


# ─── Ecliptic positions ───────────────────────────────────────────────────────

def get_ecliptic_longitude(jd_ut: float, body_key: str) -> float:
    """
    Return ecliptic longitude (0–360°) for the named body at JD (UT).

    Handles Earth (Sun + 180°) and South_Node (North_Node + 180°).
    Returns float('nan') for unknown bodies.
    """
    if body_key == "Earth":
        return (get_ecliptic_longitude(jd_ut, "Sun") + 180.0) % 360.0

    body_id = BODY_IDS.get(body_key)
    if body_id is None:
        return float("nan")

    try:
        xx, _ = swe.calc_ut(jd_ut, body_id, _SWE_FLAGS)
    except swe.Error as e:
        logger.warning("swe.calc_ut failed for %s: %s", body_key, e)
        return float("nan")

    lon = float(xx[0]) % 360.0

    if body_key == "South_Node":
        lon = (lon + 180.0) % 360.0

    return lon


def get_planet_speed(jd_ut: float, body_key: str) -> float:
    """
    Return longitude speed (degrees/day) for the named body.
    Negative means retrograde.
    """
    if body_key in ("Earth", "South_Node"):
        return 0.0

    body_id = BODY_IDS.get(body_key)
    if body_id is None:
        return 0.0

    try:
        xx, _ = swe.calc_ut(jd_ut, body_id, _SWE_FLAGS)
    except swe.Error as e:
        logger.warning("swe.calc_ut speed failed for %s: %s", body_key, e)
        return 0.0

    return float(xx[3])


# ─── Houses ───────────────────────────────────────────────────────────────────

def calculate_houses(jd_ut: float, lat: float, lon: float, hsys: str = "W") -> dict:
    """
    Return a dict with house cusps plus the actual ASC and MC.

    Keys:
      "cusps": list of 12 floats — house cusp longitudes (0–360°), houses 1–12
      "asc":   float — true Ascendant ecliptic longitude (always the rising degree)
      "mc":    float — true MC ecliptic longitude

    For Whole Sign ('W') the cusp longitudes are the sign boundaries (multiples
    of 30° starting from the sign that contains the ASC).  The actual ASC degree
    differs from house_1 and is needed to orient the wheel correctly.

    hsys: 'W'=WholeSign, 'P'=Placidus, 'K'=Koch, 'E'=Equal, etc.
    """
    cusps, ascmc = swe.houses(jd_ut, lat, lon, hsys.encode())
    # pyswisseph's Python binding returns cusps as a 12-tuple (houses 1–12 at
    # indices 0–11), unlike the C API which has a dummy element at index 0.
    return {
        "cusps": [float(c) % 360.0 for c in cusps],
        "asc":   float(ascmc[0]) % 360.0,
        "mc":    float(ascmc[1]) % 360.0,
    }


def calculate_placidus_cusps(jd_ut: float, lat: float, lon: float) -> list:
    """Backwards-compatible alias — returns just the cusp list."""
    return calculate_houses(jd_ut, lat, lon, "P")["cusps"]


# ─── Solar crossing ───────────────────────────────────────────────────────────

def find_sun_crossing(target_lon: float, t_start: float, t_end: float = None) -> float:
    """
    Return the JD (UT) when the Sun next crosses target_lon, searching
    forward from t_start.

    Uses swe.solcross_ut() — fast, exact, no iteration needed.
    t_end is accepted for API compatibility but ignored (swe searches forward).
    """
    return swe.solcross_ut(target_lon, t_start, _SWE_FLAGS)
