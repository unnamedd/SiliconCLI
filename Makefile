EXECUTABLE_NAME = silicon

BUILD_FLAGS = -c release --disable-sandbox --arch arm64 --arch x86_64
EXECUTABLE_PATH_RELEASE = $(shell swift build $(BUILD_FLAGS) --show-bin-path)/$(EXECUTABLE_NAME)
EXECUTABLE_PATH_DEBUG = .build/debug/$(EXECUTABLE_NAME)

build:
	if [ -f $(EXECUTABLE_NAME) ]; then rm $(EXECUTABLE_NAME); fi

	swift build
	ln -s $(EXECUTABLE_PATH_DEBUG) $(EXECUTABLE_NAME)

clean:
	rm -rf .build/ $(EXECUTABLE_NAME)

build-release: clean
	swift build $(BUILD_FLAGS)
	ln -s $(EXECUTABLE_PATH_RELEASE) $(EXECUTABLE_NAME)

run: build
	./$(EXECUTABLE_NAME)

lint:
	swiftlint lint --config .swiftlint.yml

fix:
	swiftlint lint --fix --config .swiftlint.yml
	
format:
	swiftformat . --config .swiftformat

open:
	open -a /Applications/Xcode.app .
