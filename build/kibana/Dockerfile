FROM container-registry.elastic.co/kibana/kibana-ubuntu-base:latest
MAINTAINER Elastic Docker Team <docker@elastic.co>
ARG KIBANA_VERSION
EXPOSE 5601

RUN mkdir /opt/kibana
WORKDIR /opt/kibana

RUN curl -Ls https://download.elastic.co/kibana/kibana/kibana-${KIBANA_VERSION}-linux-x86_64.tar.gz | tar --strip-components=1 -zxf -
RUN /opt/kibana/bin/kibana-plugin install x-pack

WORKDIR /opt/kibana

# Map, as much as possible, environment variables to Kibana configuration options.
# We're aiming for Twelve-Factor configuration here.
# See: https://12factor.net/config
#
# Everything below this comment should be generated, not edited by hand.
# Use `./bin/kibana-conf-to-dockerfile kibana.yml`.
ENV ELASTICSEARCH_CUSTOMHEADERS {}
ENV ELASTICSEARCH_PINGTIMEOUT 1500
ENV ELASTICSEARCH_PRESERVEHOST True
ENV ELASTICSEARCH_REQUESTHEADERSWHITELIST ['authorization']
ENV ELASTICSEARCH_REQUESTTIMEOUT 30000
ENV ELASTICSEARCH_SHARDTIMEOUT 0
ENV ELASTICSEARCH_SSL_VERIFY True
ENV ELASTICSEARCH_STARTUPTIMEOUT 5000
ENV ELASTICSEARCH_URL http://kibana:changeme@elasticsearch:9200
ENV KIBANA_DEFAULTAPPID discover
ENV KIBANA_INDEX .kibana
ENV LOGGING_DEST stdout
ENV LOGGING_QUIET False
ENV LOGGING_SILENT False
ENV LOGGING_VERBOSE False
ENV OPS_INTERVAL 5000
ENV SERVER_BASEPATH '""'
ENV SERVER_HOST localhost
ENV SERVER_MAXPAYLOADBYTES 1048576
ENV SERVER_NAME kibana
ENV SERVER_PORT 5601
CMD /opt/kibana/bin/kibana \
        --elasticsearch.pingTimeout="${ELASTICSEARCH_PINGTIMEOUT}" \
        --elasticsearch.preserveHost="${ELASTICSEARCH_PRESERVEHOST}" \
        --elasticsearch.requestHeadersWhitelist="${ELASTICSEARCH_REQUESTHEADERSWHITELIST}" \
        --elasticsearch.requestTimeout="${ELASTICSEARCH_REQUESTTIMEOUT}" \
        --elasticsearch.shardTimeout="${ELASTICSEARCH_SHARDTIMEOUT}" \
        --elasticsearch.ssl.verify="${ELASTICSEARCH_SSL_VERIFY}" \
        --elasticsearch.startupTimeout="${ELASTICSEARCH_STARTUPTIMEOUT}" \
        --elasticsearch.url="${ELASTICSEARCH_URL}" \
        --kibana.defaultAppId="${KIBANA_DEFAULTAPPID}" \
        --kibana.index="${KIBANA_INDEX}" \
        --logging.dest="${LOGGING_DEST}" \
        --logging.quiet="${LOGGING_QUIET}" \
        --logging.silent="${LOGGING_SILENT}" \
        --logging.verbose="${LOGGING_VERBOSE}" \
        --ops.interval="${OPS_INTERVAL}" \
        --server.basePath="${SERVER_BASEPATH}" \
        --server.maxPayloadBytes="${SERVER_MAXPAYLOADBYTES}" \
        --server.name="${SERVER_NAME}" \
        --server.port="${SERVER_PORT}"
