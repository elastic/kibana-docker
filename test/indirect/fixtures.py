from __future__ import absolute_import

import requests
import urlparse
from retrying import retry
from pytest import fixture
from .exceptions import DockerStackError
from .retry import retry_settings


class Kibana(object):
    def get(self, location='/'):
        "GET a page from Kibana."
        url = urlparse.urljoin('http://kibana:5601/', location)
        return requests.get(url)


@fixture
@retry(**retry_settings)
def kibana():
    if Kibana().get().status_code != 200:
        raise DockerStackError  # and thus retry.
    else:
        return Kibana()
