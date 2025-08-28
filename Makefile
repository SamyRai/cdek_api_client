# Define variables
GEM_NAME = cdek_api_client
GEM_VERSION = $(shell grep VERSION lib/cdek_api_client/version.rb | awk '{print $$3}' | tr -d "'")
GEM_FILE = $(GEM_NAME)-$(GEM_VERSION).gem

# Define phony targets
.PHONY: all build install release push test clean vcr_check_cassettes docs docs-server version

# Default target
all: test build

# Build the gem
build:
	@echo "Building the gem..."
	gem build $(GEM_NAME).gemspec

# Install the gem locally
install:
	@echo "Installing the gem locally..."
	gem install ./$(GEM_FILE)

# Release the gem
release: test build push
	@echo "Releasing the gem..."
	gem push $(GEM_FILE)

# Push the gem version tag to GitHub
push:
	@echo "Pushing the gem to GitHub..."
	git tag v$(GEM_VERSION)
	git push origin v$(GEM_VERSION)
	git push origin main

# Build the docker image
build:
	@echo "Building the docker image..."
	sudo docker-compose build

# Run tests
test:
	@echo "Running tests..."
	sudo docker-compose run --rm app

# Clean up generated files
clean:
	@echo "Cleaning up..."
	rm -f $(GEM_FILE)
	rm -rf .yardoc
	rm -rf coverage

# Check VCR cassettes
vcr_check_cassettes:
	@echo "Checking VCR cassettes..."
	bundle exec vcr check_cassettes

# Generate documentation
docs:
	@echo "Generating documentation..."
	bundle exec yard doc

# Start documentation server
docs-server:
	@echo "Starting documentation server..."
	bundle exec yard server --reload

# Display the gem version
version:
	@echo "Gem version: $(GEM_VERSION)"
