from __future__ import absolute_import

from tests.fixtures import kibana  # noqa: F401


def test_kibana_is_200_ok(kibana):  # noqa: F811
    assert kibana.get().status_code == 200
