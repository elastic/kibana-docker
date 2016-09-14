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

... where `es_host` resolves to a hostname running Elasticsearch.
