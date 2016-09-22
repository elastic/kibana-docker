## Description

This is the official Kibana image created by Elastic Inc.
Kibana is built with [X-Pack](https://www.elastic.co/guide/en/x-pack/current/index.html).

## Image tags and hosting

The image is hosted in Elastic's own docker registry: `docker.elastic.co/kibana`

Available tags:

- 5.0.0-alpha5
- latest -> 5.0.0-alpha5

## Using the image

##### Run Kibana listening on localhost port 5601:

``` shell
docker run -d -p 5601:5601 -e 'ELASTICSEARCH_URL=http://es_host:9200' --name kibana docker.elastic.co/kibana/kibana
```

## Configuration options

Kibana settings, which are traditionally set in `kibana.yml` can be passed
as environment variables to the container with `-e`, as seen the `ELASTICSEARCH_URL`
example above.

<!--- Generate this table with ./bin/kibana-conf-to-dockerfile kibana.yml -->
| Environment Variable                    | Kibana Setting                          | Default Value               |
| :-------------------                    | :-------------                          | :------------               |
| `ELASTICSEARCH_PASSWORD`                | `elasticsearch.password`                | `changeme`                  |
| `ELASTICSEARCH_PINGTIMEOUT`             | `elasticsearch.pingTimeout`             | `1500`                      |
| `ELASTICSEARCH_PRESERVEHOST`            | `elasticsearch.preserveHost`            | `True`                      |
| `ELASTICSEARCH_REQUESTHEADERSWHITELIST` | `elasticsearch.requestHeadersWhitelist` | `Authorization`             |
| `ELASTICSEARCH_REQUESTTIMEOUT`          | `elasticsearch.requestTimeout`          | `30000`                     |
| `ELASTICSEARCH_SHARDTIMEOUT`            | `elasticsearch.shardTimeout`            | `0`                         |
| `ELASTICSEARCH_SSL_CA`                  | `elasticsearch.ssl.ca`                  | `/path/to/your/CA.pem`      |
| `ELASTICSEARCH_SSL_CERT`                | `elasticsearch.ssl.cert`                | `/path/to/your/client.crt`  |
| `ELASTICSEARCH_SSL_KEY`                 | `elasticsearch.ssl.key`                 | `/path/to/your/client.key`  |
| `ELASTICSEARCH_SSL_VERIFY`              | `elasticsearch.ssl.verify`              | `True`                      |
| `ELASTICSEARCH_STARTUPTIMEOUT`          | `elasticsearch.startupTimeout`          | `5000`                      |
| `ELASTICSEARCH_URL`                     | `elasticsearch.url`                     | `http://elasticsearch:9200` |
| `ELASTICSEARCH_USERNAME`                | `elasticsearch.username`                | `elastic`                   |
| `KIBANA_DEFAULTAPPID`                   | `kibana.defaultAppId`                   | `discover`                  |
| `KIBANA_INDEX`                          | `kibana.index`                          | `.kibana`                   |
| `LOGGING_DEST`                          | `logging.dest`                          | `stdout`                    |
| `LOGGING_QUIET`                         | `logging.quiet`                         | `False`                     |
| `LOGGING_SILENT`                        | `logging.silent`                        | `False`                     |
| `LOGGING_VERBOSE`                       | `logging.verbose`                       | `False`                     |
| `OPS_INTERVAL`                          | `ops.interval`                          | `5000`                      |
| `PID_FILE`                              | `pid.file`                              | `/var/run/kibana.pid`       |
| `SERVER_BASEPATH`                       | `server.basePath`                       | `""`                        |
| `SERVER_HOST`                           | `server.host`                           | `0.0.0.0`                   |
| `SERVER_MAXPAYLOADBYTES`                | `server.maxPayloadBytes`                | `1048576`                   |
| `SERVER_NAME`                           | `server.name`                           | `kibana`                    |
| `SERVER_PORT`                           | `server.port`                           | `5601`                      |
| `SERVER_SSL_CERT`                       | `server.ssl.cert`                       | _Null_                      |
| `SERVER_SSL_KEY`                        | `server.ssl.key`                        | _Null_                      |

## SSL
To enable SSL encryption, provide certificate and key files in PEM
format, and tell Kibana where to find them.

The files could be provided from a mounted volume, or added to your own image
with a Dockerfile like this one:

``` dockerfile
FROM docker.elastic.co/kibana/kibana
ADD mysite.crt mysite.key ./
USER root
RUN chown kibana mysite.key && chmod 0400 mysite.key
USER kibana
ENV SERVER_SSL_CERT=mysite.crt SERVER_SSL_KEY=mysite.key
```
