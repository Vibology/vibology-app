"""
Blueprint Router - Unified Astrology + Human Design endpoint
"""

from typing import Optional
from fastapi import APIRouter, HTTPException
from fastapi.responses import JSONResponse
from datetime import datetime
import json

from ..schemas.blueprint import BlueprintRequest
from .. import features as hd
from .. import hd_constants
from ..utils import serialization as cj
from ..services.geolocation import get_latitude_longitude, tf
from ..services.astro_calculator import calculate_natal_chart
from ..utils.date_utils import clean_birth_date_to_iso, clean_create_date_to_iso
from ..utils.serialization import get_incarnation_cross_map, get_profile_name

router = APIRouter()


def _normalize_planet_name(name: str) -> str:
    """Convert a planet name to lowercase snake_case key."""
    return name.lower().replace(" ", "_")


def _planets_list_to_dict(planets_list: list) -> dict:
    """Convert astrology planet list to a dict keyed by normalized planet name."""
    result = {}
    for p in planets_list:
        key = _normalize_planet_name(p["name"])
        result[key] = {
            "sign": p["sign"],
            "longitude": p["longitude"],
            "latitude": p["latitude"],
            "speed": p["speed"],
            "retrograde": p["retrograde"],
            "house": p["house"],
        }
    return result


def _hd_planets_list_to_dict(planets_list: list) -> dict:
    """Convert HD gates JSON planet list to a dict keyed by normalized planet name."""
    result = {}
    for p in planets_list:
        key = _normalize_planet_name(p["Planet"])
        result[key] = {
            "longitude": p["Lon"],
            "gate": p["Gate"],
            "line": p["Line"],
            "color": p["Color"],
            "tone": p["Tone"],
            "base": p["Base"],
            "channel_partner": p["Ch_Gate"],
            "dignity": p["dignity"],
        }
    return result


@router.post("")
async def calculate_blueprint(request: BlueprintRequest):
    """
    Calculate a unified Blueprint combining Western Astrology and Human Design.

    Single POST returns comprehensive data including:
    - Planetary positions, aspects, elements, modalities
    - HD type, authority, profile, definition, variables
    - HD gates and channels for both Personality (prs) and Design (des)
    """

    # 1. Resolve location
    if request.place:
        lat, lon = get_latitude_longitude(request.place)
        if lat is None or lon is None:
            raise HTTPException(
                status_code=400,
                detail=f"Geocoding failed for place: '{request.place}'. Check the place name or supply explicit coordinates.",
            )
        timezone_str = tf.timezone_at(lat=lat, lng=lon) or "Etc/UTC"
    else:
        lat = request.latitude
        lon = request.longitude
        timezone_str = request.timezone

    # 2. Build birth_time tuple and derive UTC offset for HD
    birth_time = (
        request.year,
        request.month,
        request.day,
        request.hour,
        request.minute,
        request.second,
    )
    try:
        utc_offset = hd.get_utc_offset_from_tz(birth_time, timezone_str)
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Timezone error: {str(e)}")

    # 3. Calculate natal astrology chart
    try:
        astro_result = calculate_natal_chart(
            name=request.name,
            year=request.year,
            month=request.month,
            day=request.day,
            hour=request.hour,
            minute=request.minute,
            lat=lat,
            lng=lon,
            tz_str=timezone_str,
            house_system=request.house_system,
        )
    except Exception as e:
        raise HTTPException(
            status_code=500, detail=f"Astrology calculation error: {str(e)}"
        )

    # 4. Calculate Human Design features
    timestamp = tuple(list(birth_time) + [float(utc_offset)])
    try:
        hd_result = hd.calc_single_hd_features(
            timestamp, report=False, channel_meaning=True, day_chart_only=False
        )
    except Exception as e:
        raise HTTPException(
            status_code=500, detail=f"Human Design calculation error: {str(e)}"
        )

    # 5. Serialize HD gates and channels
    try:
        gates_raw = json.loads(cj.gatesJSON(hd_result[6]))
        channels_raw = json.loads(cj.channelsJSON(hd_result[8], False))
    except Exception as e:
        raise HTTPException(
            status_code=500, detail=f"HD serialization error: {str(e)}"
        )

    # 6. Build meta
    design_date_iso = clean_create_date_to_iso(hd_result[10])
    try:
        design_dt = datetime.strptime(design_date_iso, "%Y-%m-%dT%H:%M:%SZ")
        design_date_str = design_dt.strftime("%Y-%m-%d")
        design_time_str = design_dt.strftime("%H:%M")
    except Exception:
        design_date_str = design_date_iso
        design_time_str = ""

    meta = {
        "name": request.name,
        "birth_date": f"{request.year}-{request.month:02d}-{request.day:02d}",
        "birth_time": f"{request.hour:02d}:{request.minute:02d}",
        "design_date": design_date_str,
        "design_time": design_time_str,
        "place": request.place or f"{lat:.4f}, {lon:.4f}",
        "coordinates": {"lat": round(lat, 4), "lon": round(lon, 4)},
        "timezone": timezone_str,
        "calculation_timestamp": datetime.utcnow().strftime("%Y-%m-%dT%H:%M:%SZ"),
        "engine": "cartographer/skyfield",
    }

    # 7. Build astrology section
    astrology = {
        "planets": _planets_list_to_dict(astro_result["planets"]),
        "houses": astro_result["houses"],
        "aspects": astro_result["aspects"],
        "lunar_phase": astro_result["lunar_phase"],
        "elements": astro_result["elements"],
        "modalities": astro_result["modalities"],
    }

    # 8. Build Human Design section
    energy_type = hd_result[0]
    type_details = hd_constants.TYPE_DETAILS_MAP.get(
        energy_type, hd_constants.TYPE_DETAILS_MAP["Unknown"]
    )
    inner_authority_code = hd_result[1]
    inc_cross_raw = hd_result[2]
    profile_raw = hd_result[4]
    definition_raw = hd_result[5]
    variables_raw = hd_result[11]
    active_chakras = list(hd_result[7])
    inactive_chakras = list(set(hd_constants.CHAKRA_LIST) - set(active_chakras))

    inner_authority_name = hd_constants.INNER_AUTHORITY_NAMES_MAP.get(
        inner_authority_code, inner_authority_code
    )
    incarnation_cross = get_incarnation_cross_map(inc_cross_raw)
    profile_name = get_profile_name(profile_raw)
    definition_name = hd_constants.DEFINITION_DB.get(
        str(definition_raw), str(definition_raw)
    )

    human_design = {
        "type": {
            "energy_type": energy_type,
            "strategy": type_details["strategy"],
            "signature": type_details["signature"],
            "not_self": type_details["not_self"],
            "aura": type_details["aura"],
        },
        "authority": {
            "inner_authority": inner_authority_name,
        },
        "profile": {
            "profile": profile_name,
            "incarnation_cross": incarnation_cross,
        },
        "definition": {
            "definition_type": definition_name,
            "defined_centers": [
                hd_constants.CHAKRA_NAMES_MAP.get(c, c) for c in active_chakras
            ],
            "undefined_centers": [
                hd_constants.CHAKRA_NAMES_MAP.get(c, c) for c in inactive_chakras
            ],
        },
        "variables": variables_raw,
        "planets": {
            "personality": _hd_planets_list_to_dict(gates_raw["prs"]["Planets"]),
            "design": _hd_planets_list_to_dict(gates_raw["des"]["Planets"]),
        },
        "channels": [c["channel"] for c in channels_raw.get("Channels", [])],
    }

    return JSONResponse(
        content={
            "meta": meta,
            "astrology": astrology,
            "human_design": human_design,
        }
    )
