SHELL=/bin/bash
ifndef KIBANA_VERSION
KIBANA_VERSION=5.0.0-rc1
endif

ifdef STAGING_BUILD_NUM
VERSION_TAG=$(KIBANA_VERSION)-${STAGING_BUILD_NUM}
KIBANA_DOWNLOAD_URL=http://staging.elastic.co/$(VERSION_TAG)/downloads/kibana/kibana-${KIBANA_VERSION}-linux-x86_64.tar.gz
X_PACK_URL=http://staging.elastic.co/$(VERSION_TAG)/downloads/kibana-plugins/x-pack/x-pack-${KIBANA_VERSION}.zip
else
VERSION_TAG=$(KIBANA_VERSION)
KIBANA_DOWNLOAD_URL=https://artifacts.elastic.co/downloads/kibana/kibana-${KIBANA_VERSION}-linux-x86_64.tar.gz
X_PACK_URL=x-pack
endif

export KIBANA_VERSION
export KIBANA_DOWNLOAD_URL
export X_PACK_URL
export VERSION_TAG

REGISTRY=docker.elastic.co
REMOTE_IMAGE=$(REGISTRY)/kibana/kibana
IMAGE_TAG=$(REMOTE_IMAGE):$(VERSION_TAG)
LATEST_TAG=$(REMOTE_IMAGE):latest
BASE_IMAGE=$(REGISTRY)/kibana/kibana-ubuntu-base:latest


test: flake8 clean-docker build
	docker-compose up -d elasticsearch kibana
	make pytest || (make clean-docker; false)
	make clean-docker

flake8:
	docker-compose run tester flake8

pytest:
	docker-compose run tester py.test

build: FORCE
	docker-compose build --pull
	docker tag kibana kibana:$(VERSION_TAG)

push: build
	docker tag kibana:$(VERSION_TAG) $(IMAGE_TAG)
	docker push $(IMAGE_TAG)

	# Only push latest if not a staging build
	if [ -z $$STAGING_BUILD_NUM ]; then \
		docker tag $(IMAGE_TAG) $(LATEST_TAG); \
		docker push $(LATEST_TAG); \
	fi

clean-docker:
	docker-compose down
	docker-compose rm --force

FORCE:
