SHELL=/bin/bash
export PATH := ./bin:./venv/bin:$(PATH)

PYTHON ?= $(shell command -v python3.5 || command -v python3.6)

ifndef ELASTIC_VERSION
ELASTIC_VERSION := $(shell ./bin/elastic-version)
endif

ifdef STAGING_BUILD_NUM
VERSION_TAG=$(ELASTIC_VERSION)-${STAGING_BUILD_NUM}
else
VERSION_TAG=$(ELASTIC_VERSION)
endif

ELASTIC_REGISTRY=docker.elastic.co
VERSIONED_IMAGE=$(ELASTIC_REGISTRY)/kibana/kibana:$(VERSION_TAG)

test: lint build docker-compose.yml
	./bin/testinfra tests

lint: venv
	  flake8 tests

build: dockerfile
	docker build --pull -t $(VERSIONED_IMAGE) build/kibana

release-manager-snapshot: clean
	RELEASE_MANAGER=true ELASTIC_VERSION=$(ELASTIC_VERSION)-SNAPSHOT make dockerfile
	docker build --network=host -t $(VERSIONED_IMAGE)-SNAPSHOT build/kibana

release-manager-release: clean
	RELEASE_MANAGER=true ELASTIC_VERSION=$(ELASTIC_VERSION) make dockerfile
	docker build --network=host -t $(VERSIONED_IMAGE) build/kibana

# Push the image to the dedicated push endpoint at "push.docker.elastic.co"
push: test
	docker tag $(VERSIONED_IMAGE) push.$(VERSIONED_IMAGE)
	docker push push.$(VERSIONED_IMAGE)
	docker rmi push.$(VERSIONED_IMAGE)

clean-test:
	$(TEST_COMPOSE) down
	$(TEST_COMPOSE) rm --force

venv: requirements.txt
	test -d venv || virtualenv --python=$(PYTHON) venv
	pip install -r requirements.txt
	touch venv

# Generate the Dockerfile from a Jinja2 template.
dockerfile: venv templates/Dockerfile.j2
	jinja2 \
	  -D elastic_version='$(ELASTIC_VERSION)' \
	  -D staging_build_num='$(STAGING_BUILD_NUM)' \
	  -D release_manager='$(RELEASE_MANAGER)' \
	  templates/Dockerfile.j2 > build/kibana/Dockerfile

# Generate docker-compose.yml from a Jinja2 template.
docker-compose.yml: venv
	jinja2 \
	  -D version_tag='$(VERSION_TAG)' \
	  templates/docker-compose.yml.j2 > docker-compose.yml

.PHONY: build clean flake8 push pytest test dockerfile docker-compose.yml
