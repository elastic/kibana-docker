from .constants import version
from .fixtures import kibana


def test_kibana_is_the_correct_version(kibana):
    assert version in kibana.stdout_of('kibana --version')


def test_opt_kibana_is_a_symlink_to_usr_share_kibana(kibana):
    assert kibana.stdout_of('realpath /opt/kibana') == '/usr/share/kibana'


def test_all_files_in_optimize_directory_are_owned_by_kibana(kibana):
    bad_files = kibana.stdout_of('find /usr/share/kibana/optimize ! -user kibana').split()
    assert len(bad_files) is 0


def test_all_files_in_kibana_directory_are_gid_zero(kibana):
    suspect_files = kibana.stdout_of('find /usr/share/kibana ! -gid 0').split()
    # Files can be created at runtime in /usr/share/kibana/data. Don't worry about them.
    relevant_files = [f for f in suspect_files if not f.startswith('/usr/share/kibana/data/')]
    assert len(relevant_files) is 0


def test_all_directories_in_kibana_directory_are_setgid(kibana):
    bad_dirs = kibana.stdout_of('find /usr/share/kibana -type d ! -perm /g+s').split()
    assert len(bad_dirs) is 0
