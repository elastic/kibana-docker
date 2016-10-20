FROM docker.elastic.co/kibana/kibana-ubuntu-base:latest
MAINTAINER Elastic Docker Team <docker@elastic.co>
ARG KIBANA_DOWNLOAD_URL
ARG X_PACK_URL
EXPOSE 5601

WORKDIR /usr/share/kibana
RUN curl -Ls ${KIBANA_DOWNLOAD_URL} | tar --strip-components=1 -zxf -
RUN bin/kibana-plugin install ${X_PACK_URL}

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
ADD ssl/kibana.example.org.* /usr/share/kibana/config/

RUN usermod --home /usr/share/kibana kibana
USER kibana
CMD /usr/local/bin/kibana-docker
