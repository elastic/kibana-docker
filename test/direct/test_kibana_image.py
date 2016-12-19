from helpers import environment, stdout_of
from constants import kibana_version_string


def test_kibana_is_the_correct_version():
    assert kibana_version_string in stdout_of('kibana --version')


def test_the_default_user_is_kibana():
    assert stdout_of('whoami') == 'kibana'


def test_that_the_user_home_directory_is_usr_share_kibana():
    assert environment('HOME') == '/usr/share/kibana'


def test_opt_kibana_is_a_symlink_to_usr_share_kibana():
    assert stdout_of('realpath /opt/kibana') == '/usr/share/kibana'


def test_default_environment_contains_no_kibana_config():
    acceptable_vars = ['HOME', 'HOSTNAME', 'TERM', 'PATH']
    defined_vars = [line.split('=')[0] for line in stdout_of('env').split()]
    for var in defined_vars:
        assert var in acceptable_vars


def test_all_files_in_optimize_directory_are_owned_by_kibana():
    bad_files = stdout_of('find /usr/share/kibana/optimize ! -user kibana').split()
    assert len(bad_files) is 0
