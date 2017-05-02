from .constants import version
from .fixtures import kibana


def test_kibana_is_the_correct_version(kibana):
    assert version in kibana.stdout_of('kibana --version')


def test_opt_kibana_is_a_symlink_to_usr_share_kibana(kibana):
    assert kibana.stdout_of('realpath /opt/kibana') == '/usr/share/kibana'


def test_all_files_in_optimize_directory_are_owned_by_kibana(kibana):
    bad_files = kibana.stdout_of('find /usr/share/kibana/optimize ! -user kibana').split()
    assert len(bad_files) is 0
