from .constants import version
from .fixtures import kibana


def test_process_is_pid_1(kibana):
    assert kibana.process.pid == 1


def test_process_is_running_as_the_correct_user(kibana):
    assert kibana.process.user == 'kibana'


def test_default_environment_contains_no_kibana_config(kibana):
    acceptable_vars = ['ELASTIC_CONTAINER', 'HOME', 'HOSTNAME', 'TERM', 'PATH', 'PWD', 'SHLVL', '_']
    for var in kibana.environment.keys():
        assert var in acceptable_vars
