# ── Stage 1: builder ──────────────────────────────────────────────────────────
FROM python:3.11-slim AS builder

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    libffi-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /build
COPY requirements.txt pyproject.toml ./
RUN pip install --no-cache-dir --prefix=/install -r requirements.txt

# Pre-download the JPL DE440s ephemeris so Cloud Run containers don't fetch it
# at request time. ~32 MB, public domain, covers 1849–2150.
# Packages are under /install (not the default site-packages), so we expose them
# via PYTHONPATH before running Python.
RUN mkdir -p /data/ephemeris && \
    PYTHONPATH=$(find /install -name 'site-packages' -type d | head -1) \
    python -c "from skyfield.api import Loader; load = Loader('/data/ephemeris'); load('de440s.bsp')"

# ── Stage 2: runtime ──────────────────────────────────────────────────────────
FROM python:3.11-slim

# Copy installed Python packages from builder
COPY --from=builder /install /usr/local

# Copy pre-downloaded ephemeris data
COPY --from=builder /data/ephemeris /data/ephemeris

WORKDIR /app
COPY src/ ./src/

# cartographer package lives under src/
ENV PYTHONPATH=/app/src

# Skyfield ephemeris path — matches what was downloaded in builder
ENV SKYFIELD_EPHEMERIS_PATH=/data/ephemeris

# Cloud Run injects PORT at runtime; default to 8080 for local docker runs
ENV PORT=8080

EXPOSE 8080

CMD ["sh", "-c", "uvicorn cartographer.api:app --host 0.0.0.0 --port ${PORT}"]
