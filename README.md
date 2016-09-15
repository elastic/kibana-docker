## Description

This is the official Kibana image created by Elastic Inc.
Kibana is built with [x-pack](https://www.elastic.co/guide/en/x-pack/current/index.html).

## Image tags and hosting

The image is hosted in Elastic's own docker registry: `container-registry.elastic.co/kibana`

Available tags:

- 5.0.0-alpha5
- latest -> 5.0.0-alpha5

## Using the image

##### Run Kibana listening on localhost port 5601:

``` shell
docker run -d -p 5601:5601 -e 'ELASTICSEARCH_URL=http://es_host:9200' container-registry.elastic.co/kibana/kibana
```

##### Configuration options

Most Kibana settings, which are traditionally set in `kibana.yml` can be passed
as environment variables to the container with `-e`, as seen the `ELASTICSEARCH_URL`
example above.

<!--- Generate this table with ./bin/kibana-conf-to-dockerfile kibana.yml -->
|Environment Variable|Kibana Setting|
|:-------------------|:-------------|
|`ELASTICSEARCH_PINGTIMEOUT` | `elasticsearch.pingTimeout`|
|`ELASTICSEARCH_PRESERVEHOST` | `elasticsearch.preserveHost`|
|`ELASTICSEARCH_REQUESTHEADERSWHITELIST` | `elasticsearch.requestHeadersWhitelist`|
|`ELASTICSEARCH_REQUESTTIMEOUT` | `elasticsearch.requestTimeout`|
|`ELASTICSEARCH_SHARDTIMEOUT` | `elasticsearch.shardTimeout`|
|`ELASTICSEARCH_SSL_VERIFY` | `elasticsearch.ssl.verify`|
|`ELASTICSEARCH_STARTUPTIMEOUT` | `elasticsearch.startupTimeout`|
|`ELASTICSEARCH_URL` | `elasticsearch.url`|
|`KIBANA_DEFAULTAPPID` | `kibana.defaultAppId`|
|`KIBANA_INDEX` | `kibana.index`|
|`LOGGING_DEST` | `logging.dest`|
|`LOGGING_QUIET` | `logging.quiet`|
|`LOGGING_SILENT` | `logging.silent`|
|`LOGGING_VERBOSE` | `logging.verbose`|
|`OPS_INTERVAL` | `ops.interval`|
|`SERVER_BASEPATH` | `server.basePath`|
|`SERVER_MAXPAYLOADBYTES` | `server.maxPayloadBytes`|
|`SERVER_NAME` | `server.name`|
|`SERVER_PORT` | `server.port`|
