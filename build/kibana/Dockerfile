FROM container-registry.elastic.co/kibana/kibana-ubuntu-base:latest
MAINTAINER Elastic Docker Team <docker@elastic.co>
ARG KIBANA_VERSION

RUN mkdir /opt/kibana
WORKDIR /opt/kibana

RUN curl -Ls https://download.elastic.co/kibana/kibana/kibana-${KIBANA_VERSION}-linux-x86_64.tar.gz | tar --strip-components=1 -zxf -
RUN /opt/kibana/bin/kibana-plugin install x-pack

WORKDIR /opt/kibana
ENV ELASTICSEARCH_URL http://elasticsearch:9200
CMD /opt/kibana/bin/kibana --elasticsearch.url=${ELASTICSEARCH_URL}
EXPOSE 5601
