from .fixtures import kibana


def test_labels(kibana):
    labels = kibana.docker_metadata['Config']['Labels']
    assert labels['org.label-schema.name'] == 'kibana'
    assert labels['org.label-schema.schema-version'] == '1.0'
    assert labels['org.label-schema.url'] == 'https://www.elastic.co/products/kibana'
    assert labels['org.label-schema.vcs-url'] == 'https://github.com/elastic/kibana-docker'
    assert labels['org.label-schema.vendor'] == 'Elastic'
    assert labels['org.label-schema.version'] == kibana.tag.replace('-SNAPSHOT', '')
    if kibana.flavor == 'oss':
        assert labels['license'] == 'Apache-2.0'
    else:
        assert labels['license'] == 'Elastic License'
