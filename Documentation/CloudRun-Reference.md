# Google Cloud Run Reference
> For deploying Cartographer (Python/FastAPI calculation engine)

## Overview

Cloud Run is a fully managed serverless platform that runs containers. Key properties for Cartographer:
- **Scales to zero** — no cost when idle
- **Request-based scaling** — cold start ~1-2s
- **Any language** — container listens on `$PORT`
- **Max request timeout**: up to 60 min (default 5 min — increase for long calculations)

---

## Prerequisites

```bash
gcloud auth login
gcloud config set project YOUR_PROJECT_ID
gcloud services enable run.googleapis.com
gcloud services enable artifactregistry.googleapis.com
```

---

## Deployment (from Cartographer/)

### Deploy from source (no Dockerfile needed)
```bash
gcloud run deploy cartographer \
  --source . \
  --region us-central1 \
  --allow-unauthenticated \
  --port 8080
```

### Deploy from Docker image
```bash
docker build -t gcr.io/PROJECT_ID/cartographer .
docker push gcr.io/PROJECT_ID/cartographer

gcloud run deploy cartographer \
  --image gcr.io/PROJECT_ID/cartographer \
  --region us-central1 \
  --allow-unauthenticated \
  --port 8080
```

### Makefile pattern (as in CLAUDE.md: `make deploy`)
```makefile
PROJECT_ID := your-project-id
REGION     := us-central1
SERVICE    := cartographer
IMAGE      := gcr.io/$(PROJECT_ID)/$(SERVICE)

deploy:
	docker build -t $(IMAGE) .
	docker push $(IMAGE)
	gcloud run deploy $(SERVICE) \
		--image $(IMAGE) \
		--region $(REGION) \
		--allow-unauthenticated \
		--port 8080 \
		--memory 512Mi \
		--cpu 1 \
		--timeout 30 \
		--max-instances 10
```

---

## Dockerfile for FastAPI + pyswisseph

```dockerfile
FROM python:3.12-slim

# Build deps for pyswisseph C extension
RUN apt-get update && apt-get install -y gcc && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY ephe/ /app/ephe/   # Swiss Ephemeris data files
COPY . .

ENV PORT=8080
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8080"]
```

---

## Environment Variables

```bash
# Set at deploy time
gcloud run deploy cartographer \
  --set-env-vars EPHE_PATH=/app/ephe,LOG_LEVEL=info

# Update without full redeploy (non-destructive)
gcloud run services update cartographer \
  --update-env-vars KEY=VALUE

# Remove a variable
gcloud run services update cartographer \
  --remove-env-vars KEY
```

**Rules:**
- `PORT` is injected automatically — do not set manually
- Never set `GOOGLE_APPLICATION_CREDENTIALS` as env var
- Use Secret Manager for tokens/keys (see below)

---

## Secrets

```bash
# Store a secret
echo -n "my-secret-value" | gcloud secrets create MY_SECRET --data-file=-

# Grant Cloud Run service account access
gcloud secrets add-iam-policy-binding MY_SECRET \
  --member="serviceAccount:PROJECT-NUMBER-compute@developer.gserviceaccount.com" \
  --role="roles/secretmanager.secretAccessor"

# Mount as env var at deploy time
gcloud run deploy cartographer \
  --set-secrets="MY_SECRET=MY_SECRET:latest"
```

---

## Scaling & Performance

```bash
gcloud run deploy cartographer \
  --min-instances 0 \      # scale to zero (default)
  --max-instances 10 \
  --concurrency 80 \       # requests per instance (default 80)
  --memory 512Mi \         # 256Mi, 512Mi, 1Gi, 2Gi, 4Gi, 8Gi, 16Gi, 32Gi
  --cpu 1 \                # 1, 2, 4, 6, 8
  --timeout 30             # seconds (max 3600)
```

**For Cartographer:** pyswisseph calculations complete in <100ms. `--memory 512Mi`, `--timeout 30`, defaults for everything else.

---

## Health Check

Cloud Run expects HTTP 2xx on any incoming request. FastAPI's `/health` covers this:

```python
@app.get("/health")
async def health():
    return {"status": "ok"}
```

---

## Logs

```bash
# Tail live logs
gcloud run services logs tail cartographer --region us-central1

# View recent logs
gcloud logging read \
  "resource.type=cloud_run_revision AND resource.labels.service_name=cartographer" \
  --limit 50
```

---

## Useful Commands

```bash
# Get service URL
gcloud run services describe cartographer \
  --region us-central1 \
  --format "value(status.url)"

# List revisions
gcloud run revisions list --service cartographer --region us-central1

# Roll back to previous revision
gcloud run services update-traffic cartographer \
  --to-revisions PREV_REVISION=100 \
  --region us-central1

# List all services
gcloud run services list --region us-central1

# Delete service
gcloud run services delete cartographer --region us-central1
```

---

## Local Testing

```bash
# Mirror Cloud Run exactly
docker run -p 8080:8080 -e PORT=8080 gcr.io/PROJECT_ID/cartographer

# Or run uvicorn directly during development
uvicorn main:app --reload --port 8080
```

---

## Pricing

- **Free tier**: 2M requests/month, 360K vCPU-seconds, 180K GiB-seconds/month
- **Scales to zero**: no charge when idle
- For a personal practice, Cartographer will almost certainly stay within free tier
