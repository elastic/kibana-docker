SHELL=/bin/bash
ifndef KIBANA_VERSION
KIBANA_VERSION=5.0.0-beta1
endif

export KIBANA_VERSION

REGISTRY=docker.elastic.co
REMOTE_IMAGE=$(REGISTRY)/kibana/kibana
VERSION_TAG=$(REMOTE_IMAGE):$(KIBANA_VERSION)
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
	docker tag kibana kibana:$(KIBANA_VERSION)

push: build
	docker tag kibana:$(KIBANA_VERSION) $(VERSION_TAG)
	docker tag $(VERSION_TAG) $(LATEST_TAG)

	docker push $(VERSION_TAG)
	docker push $(LATEST_TAG)

clean-docker:
	docker-compose down
	docker-compose rm --force

FORCE:
