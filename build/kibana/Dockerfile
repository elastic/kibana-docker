FROM docker.elastic.co/kibana/kibana-ubuntu-base:latest
MAINTAINER Elastic Docker Team <docker@elastic.co>
ARG KIBANA_VERSION
EXPOSE 5601

RUN mkdir /opt/kibana
WORKDIR /opt/kibana

RUN curl -Ls http://staging.elastic.co/${KIBANA_VERSION}-5eb5cbdb/downloads/kibana/kibana-${KIBANA_VERSION}-linux-x86_64.tar.gz | tar --strip-components=1 -zxf -
#RUN /opt/kibana/bin/kibana-plugin install x-pack
RUN bin/kibana-plugin install https://staging.elastic.co/${KIBANA_VERSION}-5eb5cbdb/downloads/kibana-plugins/x-pack/x-pack-${KIBANA_VERSION}.zip
WORKDIR /opt/kibana

# Set some Kibana configuration defaults.
ENV SERVER_NAME kibana
ENV SERVER_HOST \"0\"
ENV ELASTICSEARCH_URL http://elasticsearch:9200
ENV ELASTICSEARCH_USERNAME elastic
ENV ELASTICSEARCH_PASSWORD changeme

# Add the launcher/wrapper script. It knows how to interpret these environment
# variables and get them passed to Kibana.
ADD bin/kibana-docker /usr/local/bin/

# Add a self-signed SSL certificate for use in examples.
ADD ssl/kibana.example.org.* /opt/kibana/config/

USER kibana
CMD /usr/local/bin/kibana-docker
