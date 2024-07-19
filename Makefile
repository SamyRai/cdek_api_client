GEM_NAME = cdek_api_client
GEM_VERSION = $(shell grep VERSION lib/cdek_api_client/version.rb | awk '{print $$3}' | tr -d "'")
GEM_FILE = $(GEM_NAME)-$(GEM_VERSION).gem

.PHONY: all build install release push test clean vcr_check_cassettes docs

all: test build

build:
	@echo "Building the gem..."
	gem build $(GEM_NAME).gemspec

install:
	@echo "Installing the gem locally..."
	gem install ./$(GEM_FILE)

release: test build push
	@echo "Releasing the gem..."
	gem push $(GEM_FILE)

push:
	@echo "Pushing the gem to GitHub..."
	git tag v$(GEM_VERSION)
	git push origin v$(GEM_VERSION)
	git push origin main

test:
	@echo "Running tests..."
	bundle exec rspec

clean:
	@echo "Cleaning up..."
	rm -f $(GEM_FILE)
	rm -rf .yardoc
	rm -rf coverage

vcr_check_cassettes:
	@echo "Checking VCR cassettes..."
	bundle exec vcr check_cassettes

docs:
	@echo "Generating documentation..."
	bundle exec yard doc
