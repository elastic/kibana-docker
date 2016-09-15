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
|Environment Variable|Kibana Setting|Default Value|
|:-------------------|:-------------|:------------|
| `ELASTICSEARCH_PINGTIMEOUT` | `elasticsearch.pingTimeout` | `1500` |
| `ELASTICSEARCH_PRESERVEHOST` | `elasticsearch.preserveHost` | `True` |
| `ELASTICSEARCH_REQUESTHEADERSWHITELIST` | `elasticsearch.requestHeadersWhitelist` | `['authorization']` |
| `ELASTICSEARCH_REQUESTTIMEOUT` | `elasticsearch.requestTimeout` | `30000` |
| `ELASTICSEARCH_SHARDTIMEOUT` | `elasticsearch.shardTimeout` | `0` |
| `ELASTICSEARCH_SSL_VERIFY` | `elasticsearch.ssl.verify` | `True` |
| `ELASTICSEARCH_STARTUPTIMEOUT` | `elasticsearch.startupTimeout` | `5000` |
| `ELASTICSEARCH_URL` | `elasticsearch.url` | `http://localhost:9200` |
| `KIBANA_DEFAULTAPPID` | `kibana.defaultAppId` | `discover` |
| `KIBANA_INDEX` | `kibana.index` | `.kibana` |
| `LOGGING_DEST` | `logging.dest` | `stdout` |
| `LOGGING_QUIET` | `logging.quiet` | `False` |
| `LOGGING_SILENT` | `logging.silent` | `False` |
| `LOGGING_VERBOSE` | `logging.verbose` | `False` |
| `OPS_INTERVAL` | `ops.interval` | `5000` |
| `SERVER_BASEPATH` | `server.basePath` | _Null_ |
| `SERVER_MAXPAYLOADBYTES` | `server.maxPayloadBytes` | `1048576` |
| `SERVER_NAME` | `server.name` | `kibana` |
| `SERVER_PORT` | `server.port` | `5601` |
