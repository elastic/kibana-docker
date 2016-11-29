SHELL=/bin/bash
ifndef ELASTIC_VERSION
ELASTIC_VERSION=5.0.1
endif

ifdef STAGING_BUILD_NUM
VERSION_TAG=$(ELASTIC_VERSION)-${STAGING_BUILD_NUM}
KIBANA_DOWNLOAD_URL=http://staging.elastic.co/$(VERSION_TAG)/downloads/kibana/kibana-${ELASTIC_VERSION}-linux-x86_64.tar.gz
X_PACK_URL=http://staging.elastic.co/$(VERSION_TAG)/downloads/kibana-plugins/x-pack/x-pack-${ELASTIC_VERSION}.zip
else
VERSION_TAG=$(ELASTIC_VERSION)
KIBANA_DOWNLOAD_URL=https://artifacts.elastic.co/downloads/kibana/kibana-${ELASTIC_VERSION}-linux-x86_64.tar.gz
X_PACK_URL=x-pack
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
	( \
	  source venv/bin/activate; \
	  flake8 /test \
	)
build:
	docker-compose build --pull

push: build
	docker push $(VERSIONED_IMAGE)

clean: clean-test
	docker-compose down
	docker-compose rm --force

clean-test:
	$(TEST_COMPOSE) down
	$(TEST_COMPOSE) rm --force

venv:
	virtualenv --python=python3.5 venv
	( \
	  source venv/bin/activate; \
	  pip install -r test/direct/requirements.txt; \
	)

.PHONY: build clean flake8 push pytest test
