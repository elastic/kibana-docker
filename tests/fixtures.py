import requests
import urllib
from retrying import retry
from pytest import fixture
from .retry import retry_settings


@fixture
def kibana(host):
    class Kibana(object):
        def __init__(self):
            self.url = 'http://localhost:5601'
            self.process = host.process.get(comm='node')

            self.environment = dict(
                [line.split('=', 1) for line in self.stdout_of('env').split('\n')]
            )

        @retry(**retry_settings)
        def get(self, location='/', allow_redirects=True):
            """GET a page from Kibana."""
            url = urllib.parse.urljoin(self.url, location)
            return requests.get(url)

        def stdout_of(self, command):
            return host.run(command).stdout.strip()

    return Kibana()
