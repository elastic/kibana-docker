SHELL=/bin/bash
ELASTIC_VERSION := $(shell ./bin/elastic-version)

export PATH := ./bin:./venv/bin:$(PATH)

PYTHON ?= $(shell command -v python3.5 || command -v python3.6)
FIGLET := pyfiglet -w 160 -f puffy

# Build different images for OSS-only and full versions.
IMAGE_FLAVORS ?= oss full

default: from-release

test: lint clean-test
	$(foreach FLAVOR, $(IMAGE_FLAVORS), \
	  $(FIGLET) "test: $(FLAVOR)"; \
	  ./bin/pytest tests --image-flavor=$(FLAVOR); \
	)

# Test a snapshot image, which requires modifying the ELASTIC_VERSION to find the right images.
test-snapshot: lint clean-test
	ELASTIC_VERSION=$(ELASTIC_VERSION)-SNAPSHOT make test

lint: venv
	  flake8 tests

clean-test:
	$(foreach FLAVOR, $(IMAGE_FLAVORS), \
	  COMPOSE_FILE=".tedi/build/kibana-$(FLAVOR)/docker-compose.yml"; \
	  if test -f $$COMPOSE_FILE; then docker-compose -f $$COMPOSE_FILE down -v; fi; \
	)

clean:
	tedi clean --clean-assets

# Build images from releases on www.elastic.co.
# The default ELASTIC_VERSION might not have been released yet, so you may need
# to override it in the environment.
from-release:
	tedi build --fact=image_tag:$(ELASTIC_VERSION) \
	           --asset-set=default

# Build images from snapshots on snapshots.elastic.co
from-snapshot:
	tedi build --fact=image_tag:$(ELASTIC_VERSION)-SNAPSHOT \
	           --asset-set=remote_snapshot

venv: requirements.txt
	test -d venv || virtualenv --python=$(PYTHON) venv
	pip install -r requirements.txt
	touch venv
