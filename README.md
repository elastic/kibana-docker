 ## Description

This repository contains the official [Kibana](https://www.elastic.co/products/kibana) Docker image from [Elastic](https://www.elastic.co/).

Documentation can be found on the [Elastic web site](https://www.elastic.co/guide/en/kibana/current/docker.html).

## Supported Docker versions

The images have been tested on Docker 17.03.1-ce.

## Requirements

A full build and test requires:

- Docker
- GNU Make
- Python 3.5 with Virtualenv

## Running a build
To build an image with the latest nightly snapshot of Kibana, run:
```
make from-snapshot
```

To build an image with a released version of Kibana, check out the corresponding
branch for the version and run Make while specifying the exact version desired.
Like this:
```
git checkout 6.2
ELASTIC_VERSION=6.2.4 make
```

## Contributing, issues and testing

Acceptance tests for the image are located in the test directory, and can be invoked with `make test`.

This image is built on [CentOS 7](https://github.com/CentOS/sig-cloud-instance-images/blob/CentOS-7/docker/Dockerfile).
