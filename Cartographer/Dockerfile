# ── Stage 1: builder ──────────────────────────────────────────────────────────
FROM python:3.11-slim AS builder

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    libffi-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /build
COPY requirements.txt pyproject.toml ./
RUN pip install --no-cache-dir --prefix=/install -r requirements.txt

# Pre-download Swiss Ephemeris files from the official GitHub mirror.
# GitHub uses 600-year blocks: sepl/semo/seas_18.se1 covers ~1800–2400.
# Falls back to Moshier built-in for Sun–Pluto if a file fails (Chiron requires seas_18.se1).
# Note: curl -f fails on HTTP 4xx/5xx (unlike wget which downloads the HTML error body).
RUN apt-get update && apt-get install -y --no-install-recommends curl ca-certificates \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /data/ephe \
    && BASE=https://raw.githubusercontent.com/aloistr/swisseph/master/ephe \
    && for f in sepl_18.se1 semo_18.se1 seas_18.se1; do \
         curl -fsSL --retry 3 -o "/data/ephe/$f.tmp" "$BASE/$f" \
         && test -s "/data/ephe/$f.tmp" \
         && mv "/data/ephe/$f.tmp" "/data/ephe/$f" \
         || { rm -f "/data/ephe/$f.tmp" "/data/ephe/$f"; echo "Warning: $f unavailable, Moshier fallback active"; }; \
       done

# ── Stage 2: runtime ──────────────────────────────────────────────────────────
FROM python:3.11-slim

# Copy installed Python packages from builder
COPY --from=builder /install /usr/local

# Copy pre-downloaded ephemeris data
COPY --from=builder /data/ephe /data/ephe

WORKDIR /app
COPY src/ ./src/

# cartographer package lives under src/
ENV PYTHONPATH=/app/src

# Swiss Ephemeris path — matches what was downloaded in builder
ENV SE_EPHE_PATH=/data/ephe

# Cloud Run injects PORT at runtime; default to 8080 for local docker runs
ENV PORT=8080

EXPOSE 8080

CMD ["sh", "-c", "uvicorn cartographer.api:app --host 0.0.0.0 --port ${PORT}"]
