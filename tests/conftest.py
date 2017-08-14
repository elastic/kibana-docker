from subprocess import run


def docker_compose(config, *args):
    image_flavor = config.getoption('--image-flavor')
    compose_flags = '-f docker-compose-{0}.yml -f tests/docker-compose.yml'.format(image_flavor).split(' ')
    run(['docker-compose'] + compose_flags + list(args))


def pytest_addoption(parser):
    """Customize testinfra with config options via cli args"""
    # Let us specify which docker-compose-(image_flavor).yml file to use
    parser.addoption('--image-flavor', action='store', default='x-pack',
                     help='Docker image flavor; the suffix used in docker-compose-<flavor>.yml')


def pytest_configure(config):
    docker_compose(config, 'up', '-d')


def pytest_unconfigure(config):
    docker_compose(config, 'down', '-v')
    docker_compose(config, 'rm', '-f', '-v')
