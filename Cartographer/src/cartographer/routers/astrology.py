"""
Astrology Router — Western Astrology Calculations
Using Skyfield (MIT licensed, JPL ephemeris data)

Note: Chart image rendering endpoints (/chart, /chart/minimal) have been removed.
Chart visualization should be implemented client-side using a JS library
(e.g., astrochart.js) that accepts the JSON planet positions from /calculate.
"""

from fastapi import APIRouter, Query, HTTPException
from fastapi.responses import JSONResponse

from ..schemas.astrology import (
    AstrologyCalculateRequest,
    AstrologyCalculateResponse,
)
from ..services.astro_calculator import calculate_natal_chart, calculate_current_transits

router = APIRouter()


@router.post("/calculate", response_model=AstrologyCalculateResponse)
async def calculate_astrology(request: AstrologyCalculateRequest):
    """
    Calculate complete Western astrology natal chart.

    Returns:
    - Planetary positions (longitude, speed, retrograde, sign, house)
    - House cusps (Placidus)
    - Aspects between planets
    - Lunar phase and nodes
    - Element and modality distribution
    """
    try:
        result = calculate_natal_chart(
            name=request.name,
            year=request.year,
            month=request.month,
            day=request.day,
            hour=request.hour,
            minute=request.minute,
            lat=request.lat,
            lng=request.lng,
            tz_str=request.tz_str,
            house_system=request.house_system,
        )
        return result
    except Exception as e:
        raise HTTPException(status_code=400, detail=str(e))


@router.get("/chart")
async def generate_chart():
    """
    Chart image rendering is not available.

    Use /calculate to get planet positions as JSON, then render client-side
    using a JavaScript library such as astrochart.js.
    """
    return JSONResponse(
        status_code=501,
        content={
            "detail": (
                "Chart image rendering has been removed. "
                "Use POST /astrology/calculate to get planet positions as JSON "
                "and render the chart client-side."
            )
        },
    )


@router.get("/chart/minimal")
async def generate_minimal_chart():
    """
    Minimal chart image rendering is not available.

    Use /calculate to get planet positions as JSON, then render client-side.
    """
    return JSONResponse(
        status_code=501,
        content={
            "detail": (
                "Chart image rendering has been removed. "
                "Use POST /astrology/calculate to get planet positions as JSON "
                "and render the chart client-side."
            )
        },
    )


@router.get("/transits")
async def current_transits(
    lat: float = Query(0.0, description="Observer latitude"),
    lng: float = Query(0.0, description="Observer longitude"),
    tz_str: str = Query("UTC", description="Observer timezone"),
):
    """
    Calculate current planetary positions (transits) for a given location.

    Returns current positions of all planets and the Moon's North Node.
    """
    try:
        result = calculate_current_transits(lat=lat, lng=lng, tz_str=tz_str)
        return result
    except Exception as e:
        raise HTTPException(status_code=400, detail=str(e))
