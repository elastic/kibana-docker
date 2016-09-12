from __future__ import absolute_import

from tests.exceptions import DockerStackError
from requests.exceptions import ConnectionError


def is_worth_retrying(exception):
    for kind in [DockerStackError, ConnectionError]:
        if isinstance(exception, kind):
            return True

retry_settings = {
    'stop_max_delay': 10000,
    'wait_exponential_multiplier': 100,
    'wait_exponential_max': 1000,
    'retry_on_exception': is_worth_retrying
}
