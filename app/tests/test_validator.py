from app.collector.validator import is_valid_public_ip


def test_public_ip():
    assert is_valid_public_ip("8.8.8.8") is True

def test_private_ip():
    assert is_valid_public_ip("10.0.0.5") is False

def test_loopback_ip():
    assert is_valid_public_ip("127.0.0.1") is False

def test_invalid_ip():
    assert is_valid_public_ip("999.999.999.999") is False