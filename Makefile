EXECUTABLE_NAME_CLI = silicon-cli
EXECUTABLE_NAME_APP = silicon

BUILD_FLAGS = -c release --disable-sandbox --arch arm64 --arch x86_64
BUILDING_FILE_PATH=/tmp/silicon-building.txt

RELEASE_BUILD_PATH=$(shell swift build $(BUILD_FLAGS) --show-bin-path)
DEBUG_BUILD_PATH=$(shell swift build --show-bin-path)

EXECUTABLE_PATH_CLI_RELEASE = $(RELEASE_BUILD_PATH)/$(EXECUTABLE_NAME_CLI)
EXECUTABLE_PATH_APP_RELEASE = $(RELEASE_BUILD_PATH)/$(EXECUTABLE_NAME_APP)

EXECUTABLE_PATH_CLI_DEBUG = $(DEBUG_BUILD_PATH)/$(EXECUTABLE_NAME_CLI)
EXECUTABLE_PATH_APP_DEBUG = $(DEBUG_BUILD_PATH)/$(EXECUTABLE_NAME_APP)

.PHONY: help
help: ## Run `make` or `make help` to get an overview of available targets
	@echo ""
	@echo "\033[1;33mSilicon CLI | TUI App Project\033[0m"
	@echo ""
	@echo "Available targets:"
	@echo ""
	@# Print automatically extracted help. This works simply by extracting targets and
	@# '##' patterns from the current makefile, then printing them colored+preformatted.
	@# Stolen from: https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
	@grep -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
	       	sort | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-22s\033[0m %s\n", $$1, $$2}'

.PHONY: all
all: help

build: ## Build the project using the debug configuration
	if [ -f $(EXECUTABLE_NAME_CLI) ]; then rm $(EXECUTABLE_NAME_CLI); fi
	if [ -f $(EXECUTABLE_NAME_APP) ]; then rm $(EXECUTABLE_NAME_APP); fi

	touch $(BUILDING_FILE_PATH)
	swift build >/tmp/$(EXECUTABLE_NAME_APP)-building-output.log 2>&1

	ln -s $(EXECUTABLE_PATH_CLI_DEBUG) $(EXECUTABLE_NAME_CLI)
	ln -s $(EXECUTABLE_PATH_APP_DEBUG) $(EXECUTABLE_NAME_APP)
	rm $(BUILDING_FILE_PATH)

clean: ## Remove all building folders and symbolic links
	rm -rf .build/ .swiftpm/ $(EXECUTABLE_NAME_CLI) $(EXECUTABLE_NAME_APP)

build-release: clean # Build project for release
	swift build $(BUILD_FLAGS)
	ln -s $(EXECUTABLE_PATH_CLI_RELEASE) $(EXECUTABLE_NAME_CLI)
	ln -s $(EXECUTABLE_PATH_APP_RELEASE) $(EXECUTABLE_NAME_APP)

run: build ## Compile and run the CLI project
	./$(EXECUTABLE_NAME_CLI)

run-app: build ## Compile and run the TUI app
	./$(EXECUTABLE_NAME_APP)

run-app-hot-reloading: build ## Compile and run the TUI app without having to redo all the compile and run process
	SILICON_HOT_RELOADING=1 ./HotReloading.sh $(BUILDING_FILE_PATH) $(EXECUTABLE_NAME_APP) 2>/tmp/$(EXECUTABLE_NAME_APP)-output.log

lint: ## Run SwiftLint in the project folder
	swiftlint lint --config .swiftlint.yml

fix: ## Run lint fix from SwiftLint
	swiftlint lint --fix --config .swiftlint.yml

format: ## Formats the whole project using SwiftFormat
	swiftformat . --config .swiftformat

open: ## Open the project in Xcode
	open -a /Applications/Xcode.app .
