# ─────────────────────────────────────────────────────────────────────────────
# Cartographer — Cloud Run Makefile
# ─────────────────────────────────────────────────────────────────────────────

PROJECT_ID   ?= vibology-app
REGION       ?= us-central1
REPO         ?= vibology
SERVICE_NAME ?= cartographer

IMAGE := $(REGION)-docker.pkg.dev/$(PROJECT_ID)/$(REPO)/$(SERVICE_NAME)

.PHONY: deploy logs url

## Build with Cloud Build (native amd64 on GCP) and deploy to Cloud Run.
deploy:
	gcloud builds submit \
		--tag $(IMAGE):latest \
		--project $(PROJECT_ID)
	gcloud run deploy $(SERVICE_NAME) \
		--image $(IMAGE):latest \
		--platform managed \
		--region $(REGION) \
		--allow-unauthenticated \
		--memory 1Gi \
		--project $(PROJECT_ID)

## Tail live Cloud Run logs.
logs:
	gcloud run services logs tail $(SERVICE_NAME) \
		--region $(REGION) \
		--project $(PROJECT_ID)

## Print the public URL.
url:
	@gcloud run services describe $(SERVICE_NAME) \
		--platform managed \
		--region $(REGION) \
		--project $(PROJECT_ID) \
		--format "value(status.url)"
