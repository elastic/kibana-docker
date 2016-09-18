FROM container-registry.elastic.co/kibana/kibana-ubuntu-base:latest
MAINTAINER Elastic Docker Team <docker@elastic.co>
ARG KIBANA_VERSION
EXPOSE 5601

RUN mkdir /opt/kibana
WORKDIR /opt/kibana

RUN curl -Ls https://download.elastic.co/kibana/kibana/kibana-${KIBANA_VERSION}-linux-x86_64.tar.gz | tar --strip-components=1 -zxf -
RUN /opt/kibana/bin/kibana-plugin install x-pack

WORKDIR /opt/kibana

# Set some Kibana configuration defaults.
ENV SERVER_NAME kibana
ENV ELASTICSEARCH_URL http://elasticsearch:9200
ENV ELASTICSEARCH_USERNAME elastic
ENV ELASTICSEARCH_PASSWORD changeme

# Add the launcher/wrapper script. It knows how to interpret these environment
# variables and get them passed to Kibana.
ADD bin/kibana-docker /usr/local/bin/

# Add a self-signed SSL certificate for use in examples.
ADD ssl/kibana.example.org.* /opt/kibana/config/

CMD /usr/local/bin/kibana-docker
