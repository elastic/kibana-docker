from .fixtures import kibana  # noqa: F401
from requests import codes


def test_kibana_is_200_ok(kibana):  # noqa: F811
    assert kibana.get().status_code == codes.ok
