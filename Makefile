SHELL=/bin/bash
ifndef ELASTIC_VERSION
ELASTIC_VERSION=5.0.0-rc1
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

test: flake8 clean build
	$(TEST_COMPOSE) up -d elasticsearch kibana
	make pytest || (make clean; false)
	make clean

flake8:
	$(TEST_COMPOSE) run --rm tester flake8 /tmp/tests

pytest:
	$(TEST_COMPOSE) run --rm tester py.test -p no:cacheprovider /tmp/tests

build:
	docker-compose build --pull

push: build
	docker push $(VERSIONED_IMAGE)

	# Only push latest if not a staging build
	if [ -z $$STAGING_BUILD_NUM ]; then \
		docker tag $(VERSIONED_IMAGE) $(LATEST_IMAGE); \
		docker push $(LATEST_IMAGE); \
	fi

clean: clean-test
	docker-compose down
	docker-compose rm --force

clean-test:
	$(TEST_COMPOSE) down
	$(TEST_COMPOSE) rm --force

.PHONY: build clean flake8 push pytest test
