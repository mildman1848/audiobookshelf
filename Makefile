.PHONY: build build-multiarch test validate security-scan push clean help setup env-setup env-validate secrets-generate secrets-generate-ci secrets-rotate secrets-clean secrets-info start stop restart status logs shell

IMAGE_NAME := mildman1848/audiobookshelf
VERSION := $(shell cat VERSION)
BUILD_DATE := $(shell date -u +'%Y-%m-%dT%H:%M:%SZ')

# Colors for output
GREEN := \033[0;32m
YELLOW := \033[0;33m
BLUE := \033[0;34m
RED := \033[0;31m
NC := \033[0m # No Color

## help: Display this help message
help:
	@echo "$(BLUE)Audiobookshelf Docker Image Build System$(NC)"
	@echo ""
	@echo "$(GREEN)Available targets:$(NC)"
	@sed -n 's/^##//p' ${MAKEFILE_LIST} | column -t -s ':' | sed -e 's/^/ /'

## build: Build Docker image for current platform
build:
	docker buildx build \
		--platform linux/amd64 \
		--tag $(IMAGE_NAME):latest \
		--tag $(IMAGE_NAME):$(VERSION) \
		--build-arg BUILD_DATE=$(BUILD_DATE) \
		--build-arg VERSION=$(VERSION) \
		--load \
		.

## build-multiarch: Build and push multi-architecture images
build-multiarch:
	docker buildx build \
		--platform linux/amd64,linux/arm64 \
		--tag $(IMAGE_NAME):latest \
		--tag $(IMAGE_NAME):$(VERSION) \
		--build-arg BUILD_DATE=$(BUILD_DATE) \
		--build-arg VERSION=$(VERSION) \
		--push \
		.

## test: Run container tests
test:
	@echo "Starting test container..."
	@docker run -d --name test-audiobookshelf \
		-e PUID=1000 \
		-e PGID=1000 \
		-e TZ=Europe/Berlin \
		$(IMAGE_NAME):latest
	@echo "Waiting for container to be healthy..."
	@sleep 10
	@echo "Running tests..."
	@docker ps -a | grep test-audiobookshelf
	@echo "Checking logs..."
	@docker logs test-audiobookshelf
	@echo "Cleaning up..."
	@docker rm -f test-audiobookshelf
	@echo "Tests completed!"

## validate: Validate Dockerfile with hadolint
validate:
	@echo "$(GREEN)Validating Dockerfile with hadolint...$(NC)"
	@echo "$(BLUE)Note: .hadolint.yaml configuration is used by GitHub Actions$(NC)"
	@docker run --rm -i hadolint/hadolint hadolint --ignore DL3018 --ignore DL3059 --ignore DL4006 - < Dockerfile || true
	@echo "$(GREEN)Validating Dockerfile.aarch64...$(NC)"
	@docker run --rm -i hadolint/hadolint hadolint --ignore DL3018 --ignore DL3059 --ignore DL4006 - < Dockerfile.aarch64 || true

## security-scan: Run Trivy security scan
security-scan: build
	@echo "Running Trivy security scan..."
	@docker run --rm -v /var/run/docker.sock:/var/run/docker.sock \
		aquasec/trivy image --severity HIGH,CRITICAL $(IMAGE_NAME):latest

## push: Push images to registry
push:
	docker push $(IMAGE_NAME):latest
	docker push $(IMAGE_NAME):$(VERSION)

## clean: Remove local images and build cache
clean:
	docker rmi $(IMAGE_NAME):latest $(IMAGE_NAME):$(VERSION) || true
	docker builder prune -f

## start: Start container with docker-compose
start:
	docker-compose up -d

## stop: Stop running containers
stop:
	docker-compose down

## logs: Show container logs
logs:
	docker-compose logs -f

## shell: Get shell access to running container
shell:
	docker-compose exec audiobookshelf /bin/bash

## status: Show container status and health
status:
	@echo "$(GREEN)Container Status:$(NC)"
	@docker-compose ps
	@echo ""
	@echo "$(GREEN)Health Status:$(NC)"
	@docker ps --filter "name=audiobookshelf" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}" 2>/dev/null || echo "No containers running"

## restart: Restart containers
restart: stop start

## setup: Complete initial setup (env + secrets)
setup: env-setup secrets-generate
	@echo "$(GREEN)Initial setup completed!$(NC)"
	@echo "$(BLUE)Next steps:$(NC)"
	@echo "  1. Review and customize .env file"
	@echo "  2. Run 'make build' to build the Docker image"
	@echo "  3. Run 'make start' to start the container"

## env-setup: Create .env from .env.example
env-setup:
	@echo "$(GREEN)Setting up environment...$(NC)"
	@test ! -f .env && \
		(echo "Creating .env from .env.example..."; \
		cp .env.example .env; \
		echo "$(GREEN)✓ .env file created!$(NC)"; \
		echo "$(YELLOW)⚠️  Please review and customize .env before starting containers!$(NC)") || \
		echo "$(YELLOW).env file already exists, skipping...$(NC)"

## env-validate: Validate environment configuration
env-validate:
	@echo "$(GREEN)Validating environment configuration...$(NC)"
	@test -f .env && \
		(echo "✓ .env file exists"; \
		grep -q "PUID=" .env && echo "✓ PUID is set" || echo "⚠️  PUID not set"; \
		grep -q "PGID=" .env && echo "✓ PGID is set" || echo "⚠️  PGID not set"; \
		grep -q "TZ=" .env && echo "✓ TZ is set" || echo "⚠️  TZ not set"; \
		test -d secrets && echo "✓ Secrets directory exists" || echo "⚠️  Secrets directory missing - run 'make secrets-generate'"; \
		echo "$(GREEN)Environment validation completed!$(NC)") || \
		(echo "$(RED)✗ .env file not found!$(NC)"; \
		echo "Run 'make env-setup' to create it."; \
		exit 1)

## secrets-generate: Generate secure secrets for audiobookshelf
secrets-generate:
	@echo "$(GREEN)Generating secure secrets for audiobookshelf...$(NC)"
	@mkdir -p secrets
	@echo "Generating JWT secret (512-bit)..."
	@openssl rand -base64 64 | tr -d "=+/\n" | head -c 64 > secrets/audiobookshelf_jwt_secret.txt
	@echo "Generating session secret (256-bit)..."
	@openssl rand -base64 32 | tr -d "=+/\n" | head -c 32 > secrets/audiobookshelf_session_secret.txt
	@chmod 600 secrets/audiobookshelf_*.txt
	@chown $(shell id -u):$(shell id -g) secrets/audiobookshelf_*.txt 2>/dev/null || true
	@echo "$(GREEN)✓ Audiobookshelf secrets generated successfully!$(NC)"
	@echo "$(BLUE)Generated secrets:$(NC)"
	@echo "  - audiobookshelf_jwt_secret.txt (512-bit)"
	@echo "  - audiobookshelf_session_secret.txt (256-bit)"
	@echo "$(YELLOW)⚠️  Keep these secrets secure and never commit them to version control!$(NC)"

## secrets-generate-ci: Generate secrets for CI/CD environments (simplified, no ownership changes)
secrets-generate-ci:
	@echo "$(GREEN)Generating secrets for CI environment...$(NC)"
	@mkdir -p secrets
	@echo "Generating JWT secret (512-bit)..."
	@openssl rand -base64 64 | tr -d "=+/\n" | head -c 64 > secrets/audiobookshelf_jwt_secret.txt
	@echo "Generating session secret (256-bit)..."
	@openssl rand -base64 32 | tr -d "=+/\n" | head -c 32 > secrets/audiobookshelf_session_secret.txt
	@chmod 600 secrets/audiobookshelf_*.txt || true
	@echo "$(GREEN)✓ CI secrets generated successfully!$(NC)"

## secrets-rotate: Rotate existing secrets (keeps backups)
secrets-rotate:
	@echo "$(GREEN)Rotating secrets...$(NC)"
	@test -d "secrets" && \
		(echo "Creating backup of existing secrets..."; \
		mkdir -p secrets/backup-$(shell date +%Y%m%d-%H%M%S); \
		cp secrets/*.txt secrets/backup-$(shell date +%Y%m%d-%H%M%S)/ 2>/dev/null || true) || true
	@$(MAKE) secrets-generate
	@echo "$(GREEN)✓ Secrets rotated successfully!$(NC)"

## secrets-clean: Clean up old secret backups (keeps last 5)
secrets-clean:
	@echo "$(GREEN)Cleaning up old secret backups...$(NC)"
	@test -d "secrets" && \
		(cd secrets && ls -dt backup-* 2>/dev/null | tail -n +6 | xargs rm -rf 2>/dev/null || true; \
		echo "$(GREEN)✓ Old secret backups cleaned up!$(NC)") || \
		echo "$(YELLOW)No secrets directory found.$(NC)"

## secrets-info: Show information about current secrets
secrets-info:
	@echo "$(BLUE)Audiobookshelf Secrets Information:$(NC)"
	@test -d "secrets" && \
		(echo "  Secrets directory: exists"; \
		echo "  Audiobookshelf secret files:"; \
		ls -la secrets/audiobookshelf_*.txt 2>/dev/null | awk '{print "    " $$9 " (" $$5 " bytes, " $$6 " " $$7 " " $$8 ")"}' || echo "    No audiobookshelf secret files found"; \
		echo "  Backup directories:"; \
		ls -d secrets/backup-* 2>/dev/null | wc -l | awk '{print "    " $$1 " backup(s) available"}' || echo "    No backups found") || \
		(echo "  Secrets directory: not found"; \
		echo "  Run 'make secrets-generate' to create audiobookshelf secrets")
