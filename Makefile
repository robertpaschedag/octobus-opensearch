REGISTRY        ?= octobus.common.repositories.cloud.sap/opensearchproject
IMAGE_NAME      ?= octobus-opensearch
OPENSEARCH_VERSION ?= 3.9.0
TAG             ?= $(OPENSEARCH_VERSION)
PLATFORMS       ?= linux/amd64,linux/arm64
BUILDER_NAME    ?= octobus-multiarch

IMAGE           := $(REGISTRY)/$(IMAGE_NAME):$(TAG)

.PHONY: build build-local create-builder

create-builder:
	docker buildx create --name $(BUILDER_NAME) --use --bootstrap || docker buildx use $(BUILDER_NAME)

build: ## Multi-arch build + push
	docker buildx build \
		--platform $(PLATFORMS) \
		--build-arg OPENSEARCH_VERSION=$(OPENSEARCH_VERSION) \
		-t $(IMAGE) \
		--push .

build-local: ## Single-arch build for local testing
	docker buildx build \
		--build-arg OPENSEARCH_VERSION=$(OPENSEARCH_VERSION) \
		-t $(IMAGE) \
		--load .
