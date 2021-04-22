.DEFAULT_GOAL := all
.PHONY: help
help: ## This help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

down: ## Stop containers
	@docker-compose down

up: ## Start container (dev only!)
	@docker-compose up

nvidia: ## Start container with nvidia runtime (needs nvidia-container-toolkit!)
	@docker-compose -f docker-compose.yml -f docker-compose.nvidia.yml up -d

build: ## Build docker image
	@docker-compose -f docker-compose.yml -f docker-compose.build.yml build

xorg: ## Init X.org Server
	@sh -c 'Xorg &'

stopx: ## Stop X.org Server
	@sh -c 'pkill -15 Xorg'

prune: stopx down  ## Prune container & stop X.org

all: xorg nvidia ## Start X.org & start container (default)