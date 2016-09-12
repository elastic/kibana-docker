FROM alpine:latest

RUN apk update && \
    apk upgrade && \
    apk add openssl python python-dev py-pip && \
    rm -rf /var/cache/apk/*

RUN pip install --upgrade --quiet \
    flake8 \
    requests \
    retrying \
    pytest

RUN adduser -D testuser

USER testuser

RUN mkdir /tmp/tests
WORKDIR /tmp/tests
CMD py.test
