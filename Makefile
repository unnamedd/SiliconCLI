EXECUTABLE_NAME = silicon

EXECUTABLE_PATH_RELEASE = .build/release/$(EXECUTABLE_NAME)
EXECUTABLE_PATH_DEBUG = .build/debug/$(EXECUTABLE_NAME)

clean:
	rm -rf .build/ $(EXECUTABLE_NAME)

build-release: clean
	swift build -c release --disable-sandbox
	ln -s $(EXECUTABLE_PATH_RELEASE) $(EXECUTABLE_NAME)

build:
	if [ -f $(EXECUTABLE_NAME) ]; then rm $(EXECUTABLE_NAME); fi

	swift build
	ln -s $(EXECUTABLE_PATH_DEBUG) $(EXECUTABLE_NAME)

run: build
	./$(EXECUTABLE_NAME)

lint:
	swiftlint lint --config swiftlint.yml

fix:
	swiftlint lint --fix --config swiftlint

open:
	open -a /Applications/Xcode.app .
