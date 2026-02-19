# Cartographer API Reference

Cartographer is the Vibology calculation engine — a Python/FastAPI service deployed to Google Cloud Run. It wraps Swiss Ephemeris (pyswisseph) and Kerykeion to compute natal astrology charts and Human Design bodygraphs.

**Base URL (production):** deployed on Google Cloud Run (see `Cartographer/Makefile` for deploy target)
**Base URL (local dev):** `http://localhost:8000`
**Docs:** `GET /docs` (Swagger UI), `GET /redoc`

---

## Authentication

Optional. Set `HD_API_TOKEN` env var on the server to enable.
When enabled, pass `X-Api-Token: <token>` header on all requests.
For local development the token is disabled by default.

---

## Primary Endpoint: `POST /blueprint`

**The main endpoint the macOS app uses.** Returns a unified JSON object combining a complete Western astrology natal chart and a full Human Design bodygraph in a single request.

### Request

```json
{
  "name": "Joe Lewis",
  "year": 1978,
  "month": 9,
  "day": 18,
  "hour": 17,
  "minute": 34,
  "second": 0,
  "place": "South Williamson, KY, United States"
}
```

**Fields:**

| Field | Type | Required | Notes |
|-------|------|----------|-------|
| `name` | string | yes | Display name |
| `year` | int | yes | Birth year |
| `month` | int | yes | 1–12 |
| `day` | int | yes | 1–31 |
| `hour` | int | yes | 0–23, local time |
| `minute` | int | yes | 0–59 |
| `second` | int | no | Default 0 |
| `place` | string | either/or | Geocoded to lat/lon/timezone |
| `latitude` | float | either/or | Used instead of `place` |
| `longitude` | float | either/or | Used instead of `place` |
| `timezone` | string | either/or | IANA string, e.g. `"America/New_York"` |
| `house_system` | string | no | Default `"P"` (Placidus). Also: `"W"` Whole Sign, `"K"` Koch |

Provide either `place` **or** all three of `latitude` + `longitude` + `timezone`.

### Response Structure

```
{
  "meta": { ... },
  "astrology": {
    "planets": { ... },
    "houses": { ... },
    "aspects": [ ... ],
    "lunar_phase": { ... },
    "elements": { ... },
    "modalities": { ... }
  },
  "human_design": {
    "type": { ... },
    "authority": { ... },
    "profile": { ... },
    "definition": { ... },
    "variables": { ... },
    "planets": {
      "personality": { ... },
      "design": { ... }
    },
    "channels": [ ... ]
  }
}
```

### `meta`

```json
{
  "name": "Joe Lewis",
  "birth_date": "1978-09-18",
  "birth_time": "17:34",
  "design_date": "1978-06-19",
  "design_time": "05:58",
  "place": "South Williamson, KY, United States",
  "coordinates": { "lat": 37.6721, "lon": -82.2839 },
  "timezone": "America/New_York",
  "calculation_timestamp": "2026-02-19T17:45:29Z",
  "engine": "cartographer/pyswisseph"
}
```

`design_date` / `design_time` is ~88 days before birth — the Human Design "Design" calculation point (UTC).

### `astrology.planets`

Dict keyed by lowercase snake_case planet name. Contains 12 planets: `sun`, `moon`, `mercury`, `venus`, `mars`, `jupiter`, `saturn`, `uranus`, `neptune`, `pluto`, `mean_north_lunar_node`, `chiron`.

```json
{
  "sun": {
    "sign": "Vir",
    "longitude": 175.607,
    "latitude": 0.0,
    "speed": 0.976,
    "retrograde": false,
    "house": 7
  },
  "moon": { "sign": "Ari", "longitude": 23.131, "house": 2, ... },
  ...
}
```

**Sign abbreviations:** `Ari` `Tau` `Gem` `Can` `Leo` `Vir` `Lib` `Sco` `Sag` `Cap` `Aqu` `Pis`

`house` is an integer 1–12. `longitude` is absolute ecliptic longitude 0–360°.

### `astrology.houses`

```json
{
  "house_1": 312.494,
  "house_2": 348.12,
  ...
  "house_12": 276.33
}
```

Values are absolute ecliptic longitudes of each house cusp (0–360°).

### `astrology.aspects`

Array of aspect objects. Typically 40–60 aspects depending on orb settings.

```json
[
  {
    "planet1": "Sun",
    "planet2": "True_North_Lunar_Node",
    "aspect": "conjunction",
    "orb": 1.1292,
    "applying": true
  },
  {
    "planet1": "Mercury",
    "planet2": "Saturn",
    "aspect": "conjunction",
    "orb": 8.8027,
    "applying": false
  }
]
```

`applying: true` means the orb is closing (aspect perfects in the future).
`aspect` values: `conjunction`, `opposition`, `trine`, `square`, `sextile`, `quincunx`, `semisextile`, `semisquare`, `sesquiquadrate`, `quintile`, `biquintile`.

### `astrology.lunar_phase`

```json
{
  "degrees_between_s_m": 207.52,
  "moon_phase": 17,
  "moon_phase_name": "Waning Gibbous"
}
```

`moon_phase` is 0–28 (lunar day). Phase names: New Moon, Waxing Crescent, First Quarter, Waxing Gibbous, Full Moon, Waning Gibbous, Last Quarter, Waning Crescent.

### `astrology.elements` and `astrology.modalities`

Counts of planets in each element/modality (based on the 12 planetary signs).

```json
{ "Fire": 3, "Earth": 4, "Air": 2, "Water": 2 }
{ "Cardinal": 3, "Fixed": 4, "Mutable": 4 }
```

### `human_design.type`

```json
{
  "energy_type": "Generator",
  "strategy": "Wait to Respond",
  "signature": "Satisfaction",
  "not_self": "Frustration",
  "aura": "Open & Enveloping"
}
```

`energy_type` values: `Generator`, `Manifesting Generator`, `Projector`, `Manifestor`, `Reflector`.

### `human_design.authority`

```json
{ "inner_authority": "Emotional Authority" }
```

Authority values: `Emotional Authority`, `Sacral Authority`, `Splenic Authority`, `Ego-Manifested Authority`, `Self-Projected Authority`, `Ego-Projected Authority`, `Lunar Authority`, `No Inner Authority`.

### `human_design.profile`

```json
{
  "profile": "4/6: Opportunist Role Model",
  "incarnation_cross": "Right Angle Cross of Eden (3)"
}
```

### `human_design.definition`

```json
{
  "definition_type": "Single Definition",
  "defined_centers": ["Spleen", "Sacral", "G_Center", "Solar Plexus"],
  "undefined_centers": ["Ajna", "Heart", "Head", "Root", "Throat"]
}
```

`definition_type` values: `Single Definition`, `Split Definition`, `Triple Split Definition`, `Quadruple Split Definition`, `No Definition (Reflector)`.

Center names: `Head`, `Ajna`, `Throat`, `G_Center`, `Heart`, `Sacral`, `Solar Plexus`, `Spleen`, `Root`.

### `human_design.variables`

Raw variables dict from the HD calculation — 4 arrows (top-left, bottom-left, top-right, bottom-right), each with a `value` (`"left"` or `"right"`). Used to determine digestion, environment, motivation, and perspective.

### `human_design.planets`

Two sub-dicts: `personality` (conscious, black) and `design` (unconscious, red). Each keyed by planet name. 13 planets each: `sun`, `earth`, `moon`, `north_node`, `south_node`, `mercury`, `venus`, `mars`, `jupiter`, `saturn`, `uranus`, `neptune`, `pluto`.

```json
{
  "personality": {
    "sun": {
      "longitude": 175.607,
      "gate": 6,
      "line": 4,
      "color": 2,
      "tone": 1,
      "base": 3,
      "channel_partner": 59,
      "dignity": "exalted"
    },
    "moon": { "gate": 42, "line": 3, ... },
    ...
  },
  "design": {
    "sun": { "gate": 10, ... },
    ...
  }
}
```

`channel_partner` is the gate on the other end of an active channel (0 if no channel).
`dignity` values: `"exalted"`, `"detriment"`, `"in fall"`, `"in domicile"`, `""` (neutral).

### `human_design.channels`

Array of active channel name strings.

```json
[
  "6/59: The Channel of Mating (A Design Focused on Reproduction)",
  "5/15: The Channel of Rhythm (A Design of Being in the Flow)",
  "34/57: The Channel of Power (A Design of an Archetype)",
  "29/46: The Channel of Discovery (A Design of Succeeding Where Others Fail)"
]
```

---

## Other Endpoints

These exist but the Swift app will primarily use `/blueprint`.

### `POST /astrology/calculate`

Natal astrology only. Requires explicit `lat`, `lng`, `tz_str` (no geocoding).

### `GET /humandesign/calculate`

HD bodygraph only. Query params: `year`, `month`, `day`, `hour`, `minute`, `place`.

### `GET /humandesign/bodygraph`

Returns a PNG/SVG/JPG image of the HD bodygraph chart.

### `GET /astrology/chart`

Returns a PNG/SVG/PDF natal chart image.

### `GET /health`, `GET /humandesign/health`

Health checks. Return `{"status": "ok", ...}`.

---

## Calling from Swift

```swift
struct BlueprintRequest: Encodable {
    let name: String
    let year: Int
    let month: Int
    let day: Int
    let hour: Int
    let minute: Int
    let place: String
}

func fetchBlueprint(for client: Client) async throws -> BlueprintResponse {
    let url = URL(string: "https://<cloud-run-url>/blueprint")!
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")

    let body = BlueprintRequest(
        name: client.name,
        year: client.birthYear,
        month: client.birthMonth,
        day: client.birthDay,
        hour: client.birthHour,
        minute: client.birthMinute,
        place: client.birthPlace
    )
    request.httpBody = try JSONEncoder().encode(body)

    let (data, _) = try await URLSession.shared.data(for: request)
    return try JSONDecoder().decode(BlueprintResponse.self, from: data)
}
```

Define `BlueprintResponse` as a `Decodable` struct mirroring the JSON structure above. Use `snake_case` with `decoder.keyDecodingStrategy = .convertFromSnakeCase` or map manually.

---

## Running Locally

```bash
cd Cartographer
.venv/bin/uvicorn src.cartographer.api:app --reload --port 8000
# or
/Library/Developer/CommandLineTools/usr/bin/python3 -m uvicorn src.cartographer.api:app --port 8000
```

Test the blueprint endpoint:
```bash
curl -X POST http://localhost:8000/blueprint \
  -H "Content-Type: application/json" \
  -d '{"name":"Joe Lewis","year":1978,"month":9,"day":18,"hour":17,"minute":34,"place":"South Williamson, KY, United States"}'
```

## Deploying to Cloud Run

```bash
cd Cartographer && make deploy
```

See `Cartographer/Makefile` for the full deploy command and project/region config.
