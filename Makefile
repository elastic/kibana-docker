SHELL=/bin/bash
export PATH := ./bin:./venv/bin:$(PATH)

ifndef ELASTIC_VERSION
ELASTIC_VERSION := $(shell cat version.txt)
endif

ifdef STAGING_BUILD_NUM
VERSION_TAG=$(ELASTIC_VERSION)-${STAGING_BUILD_NUM}
else
VERSION_TAG=$(ELASTIC_VERSION)
endif

REGISTRY=docker.elastic.co
IMAGE=$(REGISTRY)/kibana/kibana
VERSIONED_IMAGE=$(IMAGE):$(VERSION_TAG)
LATEST_IMAGE=$(IMAGE):latest

export ELASTIC_VERSION
export KIBANA_DOWNLOAD_URL
export X_PACK_URL
export VERSIONED_IMAGE
export VERSION_TAG

BASE_IMAGE=$(REGISTRY)/kibana/kibana-ubuntu-base:latest

TEST_COMPOSE=docker-compose --file docker-compose.test.yml

test: flake8 clean build test-direct test-indirect

test-direct:
# Direct tests: Invoke the image in various ways and make assertions.
	( \
	  source venv/bin/activate; \
	  py.test test/direct \
	)

test-indirect:
# Indirect tests: Use a dedicated testing container to probe Kibana
# over the network.
	$(TEST_COMPOSE) up -d elasticsearch kibana
	$(TEST_COMPOSE) run --rm tester py.test -p no:cacheprovider /test/indirect || (make clean; false)
	make clean

flake8: venv
	  flake8 test

build: dockerfile
	docker build --pull -t $(VERSIONED_IMAGE) build/kibana

push: test
	docker push $(VERSIONED_IMAGE)

clean: clean-test
	docker-compose down
	docker-compose rm --force

clean-test:
	$(TEST_COMPOSE) down
	$(TEST_COMPOSE) rm --force

venv: requirements.txt
	test -d venv || virtualenv --python=python3.5 venv
	pip install -r requirements.txt
	touch venv

# Generate the Dockerfile from a Jinja2 template.
dockerfile: venv templates/Dockerfile.j2
	jinja2 \
	  -D elastic_version='$(ELASTIC_VERSION)' \
	  -D version_tag='$(VERSION_TAG)' \
	  templates/Dockerfile.j2 > build/kibana/Dockerfile

.PHONY: build clean flake8 push pytest test
