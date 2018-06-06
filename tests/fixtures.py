import requests
import json
import urllib
import os
from retrying import retry
from pytest import fixture, config
from subprocess import run, PIPE
from .retry import retry_settings


@fixture
def kibana(host):
    class Kibana(object):
        def __init__(self):
            self.version = run('./bin/elastic-version', stdout=PIPE).stdout.decode().strip()
            self.flavor = config.getoption('--image-flavor')
            self.url = 'http://localhost:5601'
            self.process = host.process.get(comm='node')
            self.image_flavor = config.getoption('--image-flavor')
            self.environment = dict(
                [line.split('=', 1) for line in self.stdout_of('env').split('\n')]
            )

            if 'STAGING_BUILD_NUM' in os.environ:
                self.tag = '%s-%s' % (self.version, os.environ['STAGING_BUILD_NUM'])
            else:
                self.tag = self.version

            if self.flavor != 'full':
                self.image = 'docker.elastic.co/kibana/kibana-%s:%s' % (self.flavor, self.tag)
            else:
                self.image = 'docker.elastic.co/kibana/kibana:%s' % (self.tag)

            self.docker_metadata = json.loads(
                run(['docker', 'inspect', self.image], stdout=PIPE).stdout)[0]

        @retry(**retry_settings)
        def get(self, location='/', allow_redirects=True):
            """GET a page from Kibana."""
            url = urllib.parse.urljoin(self.url, location)
            return requests.get(url)

        def stdout_of(self, command):
            result = host.run(command)
            assert result.rc is 0
            return result.stdout.strip()

    return Kibana()
