SHELL=/bin/bash
ELASTIC_REGISTRY ?= docker.elastic.co

export PATH := ./bin:./venv/bin:$(PATH)

# Determine the version to build. Override by setting ELASTIC_VERSION env var.
ELASTIC_VERSION := $(shell ./bin/elastic-version)

ifdef STAGING_BUILD_NUM
  VERSION_TAG=$(ELASTIC_VERSION)-${STAGING_BUILD_NUM}
else
  VERSION_TAG=$(ELASTIC_VERSION)
endif

PYTHON ?= $(shell command -v python3.5 || command -v python3.6)

IMAGE_FLAVORS ?= oss x-pack
DEFAULT_IMAGE_FLAVOR ?= x-pack

VERSIONED_IMAGE := $(ELASTIC_REGISTRY)/kibana/kibana:$(VERSION_TAG)

FIGLET := pyfiglet -w 160 -f puffy

all: build test

test: lint docker-compose
	$(foreach FLAVOR, $(IMAGE_FLAVORS), \
	  $(FIGLET) "test: $(ELASTIC_VERSION)-$(FLAVOR)"; \
	  ./bin/pytest tests --image-flavor=$(FLAVOR); \
	)

lint: venv
	  flake8 tests

build: dockerfile
	docker pull centos:7
	$(foreach FLAVOR, $(IMAGE_FLAVORS), \
	  $(FIGLET) "build: $(ELASTIC_VERSION)-$(FLAVOR)"; \
	  docker build -t $(VERSIONED_IMAGE)-$(FLAVOR) \
	    -f build/kibana/Dockerfile-$(FLAVOR) build/kibana; \
	)

# Push the image to the dedicated push endpoint at "push.docker.elastic.co"
push: test
	$(foreach FLAVOR, $(IMAGE_FLAVORS), \
	  docker tag $(VERSIONED_IMAGE)-$(FLAVOR) push.$(VERSIONED_IMAGE)-$(FLAVOR); \
	  docker push push.$(VERSIONED_IMAGE)-$(FLAVOR); \
	  docker rmi push.$(VERSIONED_IMAGE)-$(FLAVOR); \
	)
	# Also push the default version, with no suffix like '-oss' or '-x-pack'
	docker tag $(VERSIONED_IMAGE)-$(DEFAULT_IMAGE_FLAVOR) push.$(VERSIONED_IMAGE);
	docker push push.$(VERSIONED_IMAGE);
	docker rmi push.$(VERSIONED_IMAGE);

clean-test:
	$(TEST_COMPOSE) down
	$(TEST_COMPOSE) rm --force

venv: requirements.txt
	test -d venv || virtualenv --python=python3.5 venv
	pip install -r requirements.txt
	touch venv

# Generate the Dockerfiles from Jinja2 templates.
dockerfile: venv templates/Dockerfile.j2
	$(foreach FLAVOR, $(IMAGE_FLAVORS), \
	  jinja2 \
	    -D image_flavor='$(FLAVOR)' \
	    -D elastic_version='$(ELASTIC_VERSION)' \
	    -D staging_build_num='$(STAGING_BUILD_NUM)' \
	    templates/Dockerfile.j2 > build/kibana/Dockerfile-$(FLAVOR); \
	)

# Generate docker-compose files from Jinja2 templates.
docker-compose: venv
	$(foreach FLAVOR, $(IMAGE_FLAVORS), \
	  jinja2 \
	    -D version_tag='$(VERSION_TAG)' \
	    -D image_flavor='$(FLAVOR)' \
	   templates/docker-compose.yml.j2 > docker-compose-$(FLAVOR).yml; \
	)
	ln -sf docker-compose-$(DEFAULT_IMAGE_FLAVOR).yml docker-compose.yml

.PHONY: build clean flake8 push pytest test dockerfile docker-compose
