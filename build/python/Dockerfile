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

CMD ["/bin/bash"]
