import requests

from subprocess import run
from retrying import retry
from .exceptions import ExplicitRetryError
from .retry import retry_settings


def docker_compose(config, *args):
    image_flavor = config.getoption('--image-flavor')
    compose_flags = ('-f .tedi/build/kibana-%s/docker-compose.yml' % image_flavor).split()
    run(['docker-compose'] + compose_flags + list(args))


def pytest_addoption(parser):
    """Customize testinfra with config options via cli args"""
    # Let us specify which docker-compose-(image_flavor).yml file to use
    parser.addoption('--image-flavor', action='store', default='full',
                     help='Docker image flavor; the suffix used in docker-compose-<flavor>.yml')


@retry(**retry_settings)
def wait_for_kibana():
    response = requests.get('http://localhost:5601/')
    if response.status_code != requests.codes.ok:
        raise ExplicitRetryError


def pytest_configure(config):
    docker_compose(config, 'up', '-d')
    wait_for_kibana()


def pytest_unconfigure(config):
    docker_compose(config, 'down', '-v')
    docker_compose(config, 'rm', '-f', '-v')
