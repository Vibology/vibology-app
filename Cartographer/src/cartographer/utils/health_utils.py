import logging
from ..services.ephemeris import get_ecliptic_longitude, jd_to_time

logger = logging.getLogger(__name__)


def check_ephemeris_health() -> str:
    """
    Checks if the Skyfield ephemeris is functioning correctly.
    Returns "ready" if successful, "error" otherwise.
    """
    try:
        # J2000.0 epoch — Sun position at this well-known date validates the ephemeris
        t = jd_to_time(2451545.0)
        get_ecliptic_longitude(t, "Sun")
        return "ready"
    except Exception as e:
        logger.error("Skyfield ephemeris health check failed: %s", e)
        return "error"
