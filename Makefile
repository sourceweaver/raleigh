PROJECT_NAME = raleigh
ENTRY_POINT  = src/$(PROJECT_NAME).cr

SERVER_SRC_DIR = src
SERVER_BLD_DIR = dist

CLIENT_SRC_DIR = src
CLIENT_BLD_DIR = src/assets/build
CLIENT_CACHE_DIR = $(CLIENT_SRC_DIR)/.parcel-cache
APP_ASSETS_DIR = src/assets

DOCS_DIR  = docs
DOCS_PORT = 1337
PLAY_PORT = 1338

.DEFAULT_GOAL := build/all
# Calling dev_env will load "./config/dev.env"     #
# And this will make all ENV variables you defined #
# accessi
define dev_env
	$(eval include ./config/.dev.env)
	@echo "Loading dev environment..."
	$(eval export)
endef

## Documentation ##
## Commands      ##

.PHONY: docs/clean
docs/clean: ## Does Things
	rm -rf $(DOCS_DIR) || true

.PHONY: docs/generate
docs/generate: docs/clean  ## Delete the "DOCS_DIR" which is generated by the doc tool.
	crystal docs $(ENTRY_POINT)

.PHONY: docs/serve
docs/serve:
	python3 -m http.server $(DOCS_PORT) --directory $(DOCS_DIR)

.PHONY: playground/serve
playground/serve:
	crystal play -p $(PLAY_PORT)

## Development Mode     ##
## Commands             ##

.PHONY: watch/server
watch/server:
	$(call dev_env)
	bin/reflex -R 'node_modules' -R '.parcel-cache' -R 'assets' --decoration=fancy -r '\.(cr|ecr)$/' -s -- sh -c "crystal run $(ENTRY_POINT) --progress"

.PHONY: watch/client
watch/client:
	cd $(CLIENT_SRC_DIR) && npm run watch

.PHONY: watch/all
watch/all:
	make -j2 watch/client watch/server

.PHONY: fmt/server
fmt/server:
	crystal tool format

.PHONY: fmt/client
fmt/client:
	cd $(CLIENT_SRC_DIR) && npm run format

## Testing & Linting   ##
## Commands            ##

.PHONY: run/tests
run/tests: build/client
	crystal spec

.PHONY: lint/server
lint/server:
	crystal tool format --check

.PHONY: lint/client
lint/client:
	@echo "Running linters & formatters for client-side code..."
	cd $(CLIENT_SRC_DIR) && npm run lint

## Production Mode      ##
## Commands             ##
##
.PHONY: build/client
build/client:
	cd $(CLIENT_SRC_DIR) && npm run build

.PHONY: build/server
build/server:
	mkdir $(SERVER_BLD_DIR)
	crystal build $(ENTRY_POINT) -o $(SERVER_BLD_DIR)/$(PROJECT_NAME) --no-debug --release --progress

.PHONY: build/all
build/all: clean build/client build/server
	cp -R $(APP_ASSETS_DIR) $(SERVER_BLD_DIR)

## Clean-up             ##
## Commands             ##

.PHONY: clean
clean:
	rm -rf $(CLIENT_CACHE_DIR) || true
	rm -rf $(CLIENT_BLD_DIR) || true
	rm -rf $(SERVER_BLD_DIR) || true
	rm -rf .log || true
