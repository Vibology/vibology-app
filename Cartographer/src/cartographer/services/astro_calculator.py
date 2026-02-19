"""
Astrology Calculation Service - Kerykeion v5 wrapper
"""

from kerykeion.astrological_subject_factory import AstrologicalSubjectFactory
from kerykeion.aspects import AspectsFactory
from datetime import datetime
import pytz

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
    house_system: str = "P"
):
    """
    Calculate complete natal chart using Kerykeion v5.

    Returns dictionary with planets, houses, aspects, etc.
    """
    # Create AstrologicalSubjectModel via factory (offline — lat/lng/tz already resolved)
    subject = AstrologicalSubjectFactory.from_birth_data(
        name=name,
        year=year,
        month=month,
        day=day,
        hour=hour,
        minute=minute,
        lat=lat,
        lng=lng,
        tz_str=tz_str,
        online=False,
        houses_system_identifier=house_system,
    )

    # List of planets to extract
    planet_names = [
        'sun', 'moon', 'mercury', 'venus', 'mars',
        'jupiter', 'saturn', 'uranus', 'neptune', 'pluto',
        'mean_north_lunar_node', 'chiron'
    ]

    # Extract planet data
    planets_data = []
    for planet_name in planet_names:
        if hasattr(subject, planet_name):
            planet = getattr(subject, planet_name)
            if planet:  # Some might be None
                planets_data.append({
                    "name": planet.name,
                    "sign": planet.sign,
                    "longitude": planet.abs_pos,  # Absolute position 0-360
                    "latitude": 0.0,  # v5 doesn't expose latitude easily
                    "speed": getattr(planet, 'speed', 0.0),
                    "retrograde": planet.retrograde,
                    "house": int(planet.house.replace('_House', '').replace('First', '1').replace('Second', '2').replace('Third', '3').replace('Fourth', '4').replace('Fifth', '5').replace('Sixth', '6').replace('Seventh', '7').replace('Eighth', '8').replace('Ninth', '9').replace('Tenth', '10').replace('Eleventh', '11').replace('Twelfth', '12')) if planet.house else 0
                })

    # Extract house cusps
    houses_data = {}
    house_names = [
        'first_house', 'second_house', 'third_house', 'fourth_house',
        'fifth_house', 'sixth_house', 'seventh_house', 'eighth_house',
        'ninth_house', 'tenth_house', 'eleventh_house', 'twelfth_house'
    ]

    for i, house_name in enumerate(house_names, 1):
        if hasattr(subject, house_name):
            house = getattr(subject, house_name)
            if house:
                houses_data[f"house_{i}"] = house.abs_pos

    # Extract aspects via AspectsFactory
    aspects_data = []
    try:
        chart_aspects = AspectsFactory.single_chart_aspects(subject)
        for aspect in chart_aspects.aspects:
            aspects_data.append({
                "planet1": aspect.p1_name,
                "planet2": aspect.p2_name,
                "aspect": aspect.aspect,
                "orb": round(aspect.orbit, 4),
                "applying": aspect.aspect_movement.lower() == "applying"
            })
    except Exception:
        pass

    # Calculate element and modality distribution
    elements = {"Fire": 0, "Earth": 0, "Air": 0, "Water": 0}
    modalities = {"Cardinal": 0, "Fixed": 0, "Mutable": 0}

    element_map = {
        "Ari": "Fire", "Leo": "Fire", "Sag": "Fire",
        "Tau": "Earth", "Vir": "Earth", "Cap": "Earth",
        "Gem": "Air", "Lib": "Air", "Aqu": "Air",
        "Can": "Water", "Sco": "Water", "Pis": "Water"
    }

    modality_map = {
        "Ari": "Cardinal", "Can": "Cardinal", "Lib": "Cardinal", "Cap": "Cardinal",
        "Tau": "Fixed", "Leo": "Fixed", "Sco": "Fixed", "Aqu": "Fixed",
        "Gem": "Mutable", "Vir": "Mutable", "Sag": "Mutable", "Pis": "Mutable"
    }

    for planet in planets_data:
        sign = planet["sign"]
        if sign in element_map:
            elements[element_map[sign]] += 1
        if sign in modality_map:
            modalities[modality_map[sign]] += 1

    # Lunar phase
    lunar_phase_data = {
        "degrees_between_s_m": 0.0,
        "moon_phase": 0,
        "moon_phase_name": "Unknown",
    }
    if hasattr(subject, 'lunar_phase') and subject.lunar_phase is not None:
        lp = subject.lunar_phase
        lunar_phase_data = {
            "degrees_between_s_m": round(lp.degrees_between_s_m, 4),
            "moon_phase": lp.moon_phase,
            "moon_phase_name": lp.moon_phase_name,
        }

    return {
        "name": name,
        "birth_data": {
            "date": f"{year}-{month:02d}-{day:02d}",
            "time": f"{hour:02d}:{minute:02d}",
            "location": {"lat": lat, "lng": lng, "timezone": tz_str}
        },
        "planets": planets_data,
        "houses": houses_data,
        "aspects": aspects_data,
        "lunar_phase": lunar_phase_data,
        "elements": elements,
        "modalities": modalities
    }

def calculate_current_transits(lat: float, lng: float, tz_str: str):
    """Calculate current planetary positions (transits)."""
    now = datetime.now(pytz.timezone(tz_str))

    subject = AstrologicalSubject(
        name="Current Transits",
        year=now.year,
        month=now.month,
        day=now.day,
        hour=now.hour,
        minute=now.minute,
        lat=lat,
        lng=lng,
        tz_str=tz_str
    )

    planet_names = [
        'sun', 'moon', 'mercury', 'venus', 'mars',
        'jupiter', 'saturn', 'uranus', 'neptune', 'pluto'
    ]

    transits = []
    for planet_name in planet_names:
        if hasattr(subject, planet_name):
            planet = getattr(subject, planet_name)
            if planet:
                transits.append({
                    "planet": planet.name,
                    "sign": planet.sign,
                    "longitude": planet.abs_pos,
                    "retrograde": planet.retrograde
                })

    return {
        "timestamp": now.isoformat(),
        "location": {"lat": lat, "lng": lng, "timezone": tz_str},
        "transits": transits
    }
