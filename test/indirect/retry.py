from __future__ import absolute_import

from .exceptions import DockerStackError
from requests.exceptions import ConnectionError, TooManyRedirects


def is_worth_retrying(exception):
    for kind in [DockerStackError, ConnectionError, TooManyRedirects]:
        if isinstance(exception, kind):
            return True

retry_settings = {
    'stop_max_delay': 30000,
    'wait_exponential_multiplier': 100,
    'wait_exponential_max': 1000,
    'retry_on_exception': is_worth_retrying
}
