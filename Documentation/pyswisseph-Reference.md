# pyswisseph Reference
> Python bindings for the Swiss Ephemeris — used in Cartographer for natal chart and Human Design calculations
> Version 2.10.3.2 · Based on NASA JPL DE431 ephemerides · Coverage: 13201 BC – AD 17191

## Installation

```bash
pip install pyswisseph
```

```python
import swisseph as swe
```

---

## Setup

```python
# Always set ephemeris path before calculations
swe.set_ephe_path('/app/ephe')   # path to .se1 ephemeris files

# Or use bundled Moshier ephemeris (no files needed, slightly less accurate)
swe.set_ephe_path('')
```

---

## Julian Day Conversion

All swisseph functions use Julian Day (JD) as their time reference.

```python
# Calendar date → Julian Day (Universal Time)
jd = swe.julday(year, month, day, hour_decimal)
jd = swe.julday(1990, 6, 15, 14.5)          # June 15 1990 at 14:30 UT

# Julian Day → calendar date
year, month, day, hour = swe.revjul(jd)

# Convert local time to UT before calling julday
from datetime import datetime
import pytz

def local_to_jd(year, month, day, hour, minute, second, tz_name):
    dt = datetime(year, month, day, hour, minute, second,
                  tzinfo=pytz.timezone(tz_name))
    dt_utc = dt.astimezone(pytz.utc)
    decimal_hour = dt_utc.hour + dt_utc.minute/60.0 + dt_utc.second/3600.0
    return swe.julday(dt_utc.year, dt_utc.month, dt_utc.day, decimal_hour)
```

---

## Planet/Body Constants

```python
swe.SUN          # 0
swe.MOON         # 1
swe.MERCURY      # 2
swe.VENUS        # 3
swe.MARS         # 4
swe.JUPITER      # 5
swe.SATURN       # 6
swe.URANUS       # 7
swe.NEPTUNE      # 8
swe.PLUTO        # 9
swe.MEAN_NODE    # 10  North Node (mean)
swe.TRUE_NODE    # 11  North Node (true/osculating)
swe.MEAN_APOG    # 12  Black Moon Lilith (mean)
swe.OSCU_APOG    # 13  Black Moon Lilith (osculating)
swe.CHIRON       # 15
swe.PHOLUS       # 16
swe.CERES        # 17
swe.PALLAS       # 18
swe.JUNO         # 19
swe.VESTA        # 20

# Asteroids: swe.AST_OFFSET + minor_planet_number
# e.g. Eris (136199): swe.AST_OFFSET + 136199
```

---

## Calculating Planetary Positions

### `swe.calc_ut()` — primary function (Universal Time input)

```python
xx, ret_flag = swe.calc_ut(jd_ut, planet, flags)

# xx[0] = longitude (0–360°, ecliptic)
# xx[1] = latitude (degrees)
# xx[2] = distance (AU)
# xx[3] = speed in longitude (degrees/day; negative = retrograde)
# xx[4] = speed in latitude
# xx[5] = speed in distance
```

### Flags

```python
swe.FLG_SWIEPH    # Use Swiss Ephemeris files (most accurate)
swe.FLG_MOSEPH    # Use Moshier (no files needed)
swe.FLG_SPEED     # Calculate daily speed (always include for chart work)
swe.FLG_TOPOCTR   # Topocentric (requires swe.set_topo first)
swe.FLG_SIDEREAL  # Sidereal positions (requires swe.set_sid_mode first)
swe.FLG_EQUATORIAL # Equatorial coords (RA/Dec) instead of ecliptic

# Standard natal chart flag
flags = swe.FLG_SWIEPH | swe.FLG_SPEED
```

### Full natal chart planets

```python
PLANETS = [
    swe.SUN, swe.MOON, swe.MERCURY, swe.VENUS, swe.MARS,
    swe.JUPITER, swe.SATURN, swe.URANUS, swe.NEPTUNE, swe.PLUTO,
    swe.TRUE_NODE, swe.CHIRON
]

PLANET_NAMES = {
    swe.SUN: 'Sun', swe.MOON: 'Moon', swe.MERCURY: 'Mercury',
    swe.VENUS: 'Venus', swe.MARS: 'Mars', swe.JUPITER: 'Jupiter',
    swe.SATURN: 'Saturn', swe.URANUS: 'Uranus', swe.NEPTUNE: 'Neptune',
    swe.PLUTO: 'Pluto', swe.TRUE_NODE: 'North Node', swe.CHIRON: 'Chiron'
}

SIGNS = ['Aries','Taurus','Gemini','Cancer','Leo','Virgo',
         'Libra','Scorpio','Sagittarius','Capricorn','Aquarius','Pisces']

flags = swe.FLG_SWIEPH | swe.FLG_SPEED

positions = {}
for planet in PLANETS:
    xx, _ = swe.calc_ut(jd, planet, flags)
    lon = xx[0]
    positions[PLANET_NAMES[planet]] = {
        'longitude': lon,
        'latitude': xx[1],
        'speed': xx[3],
        'retrograde': xx[3] < 0,
        'sign': SIGNS[int(lon / 30)],
        'degree_in_sign': lon % 30,
    }
```

---

## House Calculations

```python
cusps, ascmc = swe.houses(jd_ut, latitude, longitude, house_system_byte)

# cusps[0]    = 0 (unused)
# cusps[1-12] = house cusp longitudes
# ascmc[0]    = Ascendant
# ascmc[1]    = Midheaven (MC)
# ascmc[2]    = ARMC
# ascmc[3]    = Vertex
```

### House systems

```python
b'P'  # Placidus (most common Western)
b'K'  # Koch
b'O'  # Porphyrius
b'R'  # Regiomontanus
b'C'  # Campanus
b'E'  # Equal (from Ascendant)
b'W'  # Whole Sign
b'X'  # Axial rotation / Meridian
b'H'  # Azimuthal / Horizontal
b'T'  # Polich/Page (topocentric)
b'B'  # Alcabitius
b'M'  # Morinus
```

### Which house is a planet in?

```python
# After getting cusps and ascmc:
armc = ascmc[2]
# Use swe.house_pos to find which house a planet occupies
house_float = swe.house_pos(armc, latitude, obliquity, b'P', planet_lon, planet_lat)
house_num = int(house_float)  # 1–12
```

---

## Human Design Calculations

Human Design uses two chart moments:
1. **Personality (conscious)** — exact birth time
2. **Design (unconscious)** — when Sun was ~88° earlier (≈88 days before birth)

```python
def get_design_jd(birth_jd: float) -> float:
    """Return JD when Sun was exactly 88° before its birth position."""
    xx, _ = swe.calc_ut(birth_jd, swe.SUN, swe.FLG_SWIEPH)
    target_lon = (xx[0] - 88) % 360
    approx_jd = birth_jd - 88

    for _ in range(10):  # Newton-Raphson iteration
        xx, _ = swe.calc_ut(approx_jd, swe.SUN, swe.FLG_SWIEPH | swe.FLG_SPEED)
        diff = (xx[0] - target_lon + 180) % 360 - 180
        approx_jd -= diff / xx[3]

    return approx_jd

def calculate_human_design(birth_jd, lat, lon):
    design_jd = get_design_jd(birth_jd)
    flags = swe.FLG_SWIEPH | swe.FLG_SPEED

    personality = {}
    design = {}
    for planet in PLANETS:
        xx, _ = swe.calc_ut(birth_jd, planet, flags)
        personality[planet] = xx[0]
        xx, _ = swe.calc_ut(design_jd, planet, flags)
        design[planet] = xx[0]

    return {'personality': personality, 'design': design, 'design_jd': design_jd}
```

---

## Obliquity & Nutation

```python
# Get true obliquity of ecliptic (needed for house_pos)
xx, _ = swe.calc_ut(jd, swe.ECL_NUT, swe.FLG_SWIEPH)
true_obliquity = xx[0]
mean_obliquity = xx[1]
nutation_lon = xx[2]
nutation_obl = xx[3]
```

---

## Fixed Stars

```python
xx, ret = swe.fixstar2_ut("Algol", jd, swe.FLG_SWIEPH)
# xx[0] = longitude, xx[1] = latitude
```

---

## Sidereal / Ayanamsa (Vedic)

```python
swe.set_sid_mode(swe.SIDM_LAHIRI)
ayanamsa = swe.get_ayanamsa_ut(jd)
# Use swe.FLG_SIDEREAL flag in calc_ut
```

---

## Cleanup

```python
swe.close()  # Release file handles (call in FastAPI lifespan shutdown)
```

---

## Ephemeris Files

Required `.se1` files — download from https://www.astro.com/ftp/swisseph/ephe/

Key files for modern charts (1800–2400 CE):
- `sepl_18.se1` — planets
- `semo_18.se1` — Moon
- `seas_18.se1` — asteroids

Place in `Cartographer/ephe/` and copy into Docker image.
