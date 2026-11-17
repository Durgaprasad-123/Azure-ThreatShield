import ipaddress

def is_valid_public_ip(ip):
    try:
        address = ipaddress.ip_address(ip)
        return address.is_global
    except ValueError:
        return False