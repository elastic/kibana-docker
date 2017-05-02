from .fixtures import kibana


def test_group_properties(host):
    group = host.group('kibana')
    assert group.exists
    assert group.gid == 1000


def test_user_properties(host):
    user = host.user('kibana')
    assert user.uid == 1000
    assert user.gid == 1000
    assert user.home == '/usr/share/kibana'
    assert user.shell == '/bin/bash'


def test_default_user_is_kibana(kibana):
    assert kibana.stdout_of('whoami') == 'kibana'


def test_that_the_user_home_directory_is_usr_share_kibana(kibana):
    assert kibana.environment['HOME'] == '/usr/share/kibana'
