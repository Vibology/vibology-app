# ── Stage 1: builder ──────────────────────────────────────────────────────────
FROM python:3.11-slim AS builder

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    libffi-dev \
    pkg-config \
    libcairo2-dev \
    libpango1.0-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /build
COPY requirements.txt pyproject.toml ./
RUN pip install --no-cache-dir --prefix=/install -r requirements.txt

# ── Stage 2: runtime ──────────────────────────────────────────────────────────
FROM python:3.11-slim

# Runtime-only native libs required by cairosvg
RUN apt-get update && apt-get install -y --no-install-recommends \
    libcairo2 \
    libpango-1.0-0 \
    libpangocairo-1.0-0 \
    libgdk-pixbuf-2.0-0 \
    && rm -rf /var/lib/apt/lists/*

# Copy installed Python packages from builder
COPY --from=builder /install /usr/local

WORKDIR /app
COPY src/ ./src/

# cartographer package lives under src/
ENV PYTHONPATH=/app/src

# Use headless matplotlib backend — no display available in Cloud Run
ENV MPLBACKEND=Agg

# Cloud Run injects PORT at runtime; default to 8080 for local docker runs
ENV PORT=8080

EXPOSE 8080

CMD ["sh", "-c", "uvicorn cartographer.api:app --host 0.0.0.0 --port ${PORT}"]
