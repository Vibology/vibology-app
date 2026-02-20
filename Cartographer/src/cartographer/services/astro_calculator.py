"""
Astrology Calculation Service — Skyfield-based natal chart calculator.

Replaces the former Kerykeion/pyswisseph wrapper.
"""

import math
from datetime import datetime
import pytz

from .ephemeris import (
    birth_to_time,
    time_to_jd,
    jd_to_time,
    get_ecliptic_longitude,
    get_planet_speed,
    calculate_placidus_cusps,
)

# ─── Zodiac & element/modality lookup tables ──────────────────────────────────

SIGNS = [
    "Ari", "Tau", "Gem", "Can", "Leo", "Vir",
    "Lib", "Sco", "Sag", "Cap", "Aqu", "Pis",
]

ELEMENT_MAP = {
    "Ari": "Fire", "Leo": "Fire", "Sag": "Fire",
    "Tau": "Earth", "Vir": "Earth", "Cap": "Earth",
    "Gem": "Air", "Lib": "Air", "Aqu": "Air",
    "Can": "Water", "Sco": "Water", "Pis": "Water",
}

MODALITY_MAP = {
    "Ari": "Cardinal", "Can": "Cardinal", "Lib": "Cardinal", "Cap": "Cardinal",
    "Tau": "Fixed",    "Leo": "Fixed",    "Sco": "Fixed",    "Aqu": "Fixed",
    "Gem": "Mutable",  "Vir": "Mutable",  "Sag": "Mutable",  "Pis": "Mutable",
}

PLANET_NAMES = [
    "Sun", "Moon", "Mercury", "Venus", "Mars",
    "Jupiter", "Saturn", "Uranus", "Neptune", "Pluto",
    "North_Node",
]

# Aspect definitions: (name, exact angle, max orb)
ASPECTS = [
    ("conjunction",  0.0,   10.0),
    ("sextile",     60.0,    6.0),
    ("square",      90.0,    8.0),
    ("trine",      120.0,    8.0),
    ("opposition", 180.0,   10.0),
]

LUNAR_PHASES = [
    (45.0,  "New Moon Phase (Initiation)"),
    (90.0,  "Waxing Crescent"),
    (135.0, "First Quarter (Action)"),
    (180.0, "Waxing Gibbous"),
    (225.0, "Full Moon (Clarity)"),
    (270.0, "Waning Gibbous"),
    (315.0, "Third Quarter (Release)"),
    (360.0, "Waning Crescent"),
]

# ─── Helpers ──────────────────────────────────────────────────────────────────

def _sign_from_lon(longitude: float) -> str:
    return SIGNS[int(longitude / 30.0) % 12]


def _house_from_lon(longitude: float, cusps: list) -> int:
    """Return the house number (1–12) for a given ecliptic longitude."""
    for i in range(12):
        next_cusp = cusps[(i + 1) % 12]
        this_cusp = cusps[i]
        if this_cusp <= next_cusp:
            if this_cusp <= longitude < next_cusp:
                return i + 1
        else:  # wraps around 360°
            if longitude >= this_cusp or longitude < next_cusp:
                return i + 1
    return 1


def _angular_diff(a: float, b: float) -> float:
    """Shortest angular distance between two longitudes (0–180)."""
    diff = abs((a - b + 180.0) % 360.0 - 180.0)
    return diff


def _lunar_phase_name(diff: float) -> str:
    for threshold, name in LUNAR_PHASES:
        if diff < threshold:
            return name
    return "Waning Crescent"


# ─── Main calculation functions ───────────────────────────────────────────────

def calculate_natal_chart(
    name: str,
    year: int,
    month: int,
    day: int,
    hour: int,
    minute: int,
    lat: float,
    lng: float,
    tz_str: str,
    house_system: str = "P",
):
    """
    Calculate complete natal chart using Skyfield + custom Placidus houses.

    Returns a dict with planets, houses, aspects, lunar_phase, elements, modalities.
    """
    # Resolve UTC offset from tz string
    tz = pytz.timezone(tz_str)
    local_dt = datetime(year, month, day, hour, minute, 0)
    tz_offset_hours = tz.utcoffset(local_dt).total_seconds() / 3600.0

    t = birth_to_time(year, month, day, hour, minute, 0, tz_offset_hours)

    # Placidus house cusps
    cusps = calculate_placidus_cusps(t, lat, lng)

    # Planet positions
    planets_data = []
    for planet_name in PLANET_NAMES:
        lon = get_ecliptic_longitude(t, planet_name)
        if math.isnan(lon):
            continue
        speed = get_planet_speed(t, planet_name)
        retrograde = speed < 0
        sign = _sign_from_lon(lon)
        house = _house_from_lon(lon, cusps)

        display_name = planet_name.replace("_", " ")
        planets_data.append({
            "name": display_name,
            "sign": sign,
            "longitude": round(lon, 6),
            "latitude": 0.0,
            "speed": round(speed, 6),
            "retrograde": retrograde,
            "house": house,
        })

    # House cusp dict
    houses_data = {f"house_{i + 1}": round(cusps[i], 6) for i in range(12)}

    # Aspects
    aspects_data = []
    for i in range(len(planets_data)):
        for j in range(i + 1, len(planets_data)):
            lon_i = planets_data[i]["longitude"]
            lon_j = planets_data[j]["longitude"]
            diff = _angular_diff(lon_i, lon_j)
            for asp_name, asp_angle, max_orb in ASPECTS:
                orb = abs(diff - asp_angle)
                if orb <= max_orb:
                    aspects_data.append({
                        "planet1": planets_data[i]["name"],
                        "planet2": planets_data[j]["name"],
                        "aspect": asp_name,
                        "orb": round(orb, 4),
                        "applying": False,  # speed-based applying/separating requires more computation
                    })
                    break  # only the closest aspect per pair

    # Elements & modalities
    elements = {"Fire": 0, "Earth": 0, "Air": 0, "Water": 0}
    modalities = {"Cardinal": 0, "Fixed": 0, "Mutable": 0}
    for planet in planets_data:
        sign = planet["sign"]
        if sign in ELEMENT_MAP:
            elements[ELEMENT_MAP[sign]] += 1
        if sign in MODALITY_MAP:
            modalities[MODALITY_MAP[sign]] += 1

    # Lunar phase
    sun_lon = next((p["longitude"] for p in planets_data if p["name"] == "Sun"), 0.0)
    moon_lon = next((p["longitude"] for p in planets_data if p["name"] == "Moon"), 0.0)
    degrees_between = (moon_lon - sun_lon) % 360.0
    moon_phase_name = _lunar_phase_name(degrees_between)
    lunar_phase_data = {
        "degrees_between_s_m": round(degrees_between, 4),
        "moon_phase": int(degrees_between / (360.0 / 8)),
        "moon_phase_name": moon_phase_name,
    }

    return {
        "name": name,
        "birth_data": {
            "date": f"{year}-{month:02d}-{day:02d}",
            "time": f"{hour:02d}:{minute:02d}",
            "location": {"lat": lat, "lng": lng, "timezone": tz_str},
        },
        "planets": planets_data,
        "houses": houses_data,
        "aspects": aspects_data,
        "lunar_phase": lunar_phase_data,
        "elements": elements,
        "modalities": modalities,
    }


def calculate_current_transits(lat: float, lng: float, tz_str: str):
    """Calculate current planetary positions (transits) for a given location."""
    tz = pytz.timezone(tz_str)
    now = datetime.now(tz)
    tz_offset_hours = tz.utcoffset(now).total_seconds() / 3600.0

    t = birth_to_time(now.year, now.month, now.day,
                      now.hour, now.minute, now.second,
                      tz_offset_hours)

    transits = []
    for planet_name in PLANET_NAMES:
        lon = get_ecliptic_longitude(t, planet_name)
        if math.isnan(lon):
            continue
        speed = get_planet_speed(t, planet_name)
        sign = _sign_from_lon(lon)
        transits.append({
            "planet": planet_name.replace("_", " "),
            "sign": sign,
            "longitude": round(lon, 6),
            "retrograde": speed < 0,
        })

    return {
        "timestamp": now.isoformat(),
        "location": {"lat": lat, "lng": lng, "timezone": tz_str},
        "transits": transits,
    }
