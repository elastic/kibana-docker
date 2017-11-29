from .exceptions import DockerStackError, ExplicitRetryError
from requests.exceptions import ConnectionError, TooManyRedirects


retriable_exceptions = [
    ExplicitRetryError,
    DockerStackError,
    ConnectionError,
    ConnectionResetError,
    TooManyRedirects
]


def is_retriable(exception):
    for retriable in retriable_exceptions:
        if isinstance(exception, retriable):
            return True
    return False


retry_settings = {
    'stop_max_delay': 120000,
    'wait_exponential_multiplier': 100,
    'wait_exponential_max': 1000,
    'retry_on_exception': is_retriable
}
