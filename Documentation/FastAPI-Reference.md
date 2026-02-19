# FastAPI Reference
> For Vibology/Cartographer — Python calculation engine on Google Cloud Run

## Overview

FastAPI is a modern Python web framework for building APIs with automatic OpenAPI documentation, type validation via Pydantic, and async support. Cartographer uses it to expose natal chart and Human Design calculation endpoints.

---

## App Setup

```python
from fastapi import FastAPI

app = FastAPI(
    title="Cartographer",
    description="Vibology calculation engine",
    version="1.0.0"
)
```

---

## Path Operations

### GET
```python
@app.get("/health")
async def health():
    return {"status": "ok"}
```

### POST (primary pattern for Cartographer)
```python
@app.post("/chart/natal", response_model=NatalChartResponse)
async def natal_chart(request: NatalChartRequest):
    ...
```

### Common decorators
```python
@app.get("/items/{item_id}")           # path parameter
@app.get("/items/")                    # query parameter
@app.post("/endpoint")                 # request body
@app.put("/items/{item_id}")
@app.delete("/items/{item_id}")
```

---

## Request & Response Models (Pydantic)

```python
from pydantic import BaseModel, Field
from typing import Optional

class NatalChartRequest(BaseModel):
    birth_date: str                    # ISO 8601: "1990-06-15"
    birth_time: str                    # "14:30:00"
    latitude: float = Field(..., ge=-90, le=90)
    longitude: float = Field(..., ge=-180, le=180)
    timezone: str                      # "America/New_York"
    house_system: str = "P"            # Placidus default

class PlanetPosition(BaseModel):
    planet: str
    longitude: float
    latitude: float
    speed: float
    house: int
    sign: str
    degree_in_sign: float
    retrograde: bool

class NatalChartResponse(BaseModel):
    planets: list[PlanetPosition]
    houses: list[float]                # 12 house cusps
    ascendant: float
    midheaven: float
    julian_day: float
```

### Field validation
```python
from pydantic import field_validator

class NatalChartRequest(BaseModel):
    house_system: str = "P"

    @field_validator("house_system")
    @classmethod
    def validate_house_system(cls, v):
        valid = {"P", "K", "O", "R", "C", "E", "W", "X"}
        if v not in valid:
            raise ValueError(f"house_system must be one of {valid}")
        return v
```

---

## Path & Query Parameters

```python
# Path parameter with type
@app.get("/charts/{chart_id}")
async def get_chart(chart_id: int):
    ...

# Optional query parameter with defaults
@app.get("/charts/")
async def list_charts(
    limit: int = 10,
    offset: int = 0,
    timezone: Optional[str] = None
):
    ...
```

---

## Async Endpoints

pyswisseph calls are CPU-bound — run them in a thread pool to avoid blocking the event loop:

```python
import asyncio
from concurrent.futures import ThreadPoolExecutor

executor = ThreadPoolExecutor()

@app.post("/chart/natal")
async def natal_chart(request: NatalChartRequest):
    loop = asyncio.get_event_loop()
    result = await loop.run_in_executor(executor, calculate_chart, request)
    return result

def calculate_chart(request: NatalChartRequest) -> dict:
    # synchronous pyswisseph calls here
    ...
```

---

## Error Handling

```python
from fastapi import HTTPException

@app.post("/chart/natal")
async def natal_chart(request: NatalChartRequest):
    try:
        result = calculate(request)
    except ValueError as e:
        raise HTTPException(status_code=422, detail=str(e))
    except Exception as e:
        raise HTTPException(status_code=500, detail="Calculation failed")
    return result
```

### Custom exception handler
```python
from fastapi import Request
from fastapi.responses import JSONResponse

@app.exception_handler(ValueError)
async def value_error_handler(request: Request, exc: ValueError):
    return JSONResponse(status_code=422, content={"detail": str(exc)})
```

---

## Dependency Injection

```python
from fastapi import Depends

def get_settings():
    return {"ephe_path": "/app/ephe"}

@app.post("/chart/natal")
async def natal_chart(
    request: NatalChartRequest,
    settings: dict = Depends(get_settings)
):
    ...
```

---

## CORS (required for any web client)

```python
from fastapi.middleware.cors import CORSMiddleware

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],        # tighten in production
    allow_methods=["*"],
    allow_headers=["*"],
)
```

---

## Lifespan (startup/shutdown)

```python
from contextlib import asynccontextmanager
import swisseph as swe

@asynccontextmanager
async def lifespan(app: FastAPI):
    # Startup: initialize Swiss Ephemeris
    swe.set_ephe_path("/app/ephe")
    yield
    # Shutdown
    swe.close()

app = FastAPI(lifespan=lifespan)
```

---

## Running Locally

```bash
# Development (auto-reload)
uvicorn main:app --reload --port 8080

# Production (as Cloud Run runs it)
uvicorn main:app --host 0.0.0.0 --port $PORT
```

---

## Dockerfile for Cloud Run

```dockerfile
FROM python:3.12-slim

RUN apt-get update && apt-get install -y gcc && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY ephe/ /app/ephe/
COPY . .

ENV PORT=8080
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8080"]
```

### requirements.txt
```
fastapi>=0.115.0
uvicorn[standard]>=0.30.0
pyswisseph>=2.10.3
pydantic>=2.0.0
```

---

## Auto-generated Docs

FastAPI generates these automatically:
- **Swagger UI**: `http://localhost:8080/docs`
- **ReDoc**: `http://localhost:8080/redoc`
- **OpenAPI JSON**: `http://localhost:8080/openapi.json`

---

## Cartographer Endpoint Checklist

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/health` | GET | Cloud Run health check |
| `/chart/natal` | POST | Full natal chart (planets + houses) |
| `/humandesign/calculate` | POST | Human Design bodygraph |
