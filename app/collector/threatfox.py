
import ipaddress
import os

import requests


def fetch_threatfox_indicators():
    api_key = os.getenv("THREATFOX_API_KEY")

    if not api_key:
        raise ValueError("API KEY is not set in environment variables")

    url = "https://threatfox-api.abuse.ch/api/v1/"

    payload = {
        "query": "get_iocs",
        "days": 1
    }

    headers = {
        "Content-Type": "application/json",
        "Auth-Key": api_key
    }

    # Fetch indicators from ThreatFox
    try:
        response = requests.post(
            url,
            json=payload,
            headers=headers,
            timeout=15
        )
        response.raise_for_status()
        data = response.json()

    except requests.exceptions.RequestException as e:
        raise RuntimeError(
            f"Error fetching data from ThreatFox: {e}"
        ) from e

    except ValueError as e:
        raise RuntimeError(
            "ThreatFox returned invalid JSON"
        ) from e

    # Validate API response
    if not isinstance(data, dict):
        raise TypeError("Unexpected ThreatFox response format")

    if data.get("query_status") != "ok":
        raise RuntimeError(
            f"ThreatFox query failed: {data.get('query_status')}"
        )

    if not isinstance(data.get("data"), list):
        raise TypeError("ThreatFox returned unexpected data format")

    indicators = []

    # Process only IP:port indicators
    for item in data["data"]:

        if not isinstance(item, dict):
            continue

        if item.get("ioc_type") != "ip:port":
            continue

        ip_port = item.get("ioc")
        confidence = item.get("confidence_level")

        if not isinstance(ip_port, str):
            continue

        try:
            # Separate IP address and port
            ip_text, port_text = ip_port.rsplit(":", 1)

            # Support bracketed IPv6 addresses
            if ip_text.startswith("[") and ip_text.endswith("]"):
                ip_text = ip_text[1:-1]

            ip = ipaddress.ip_address(ip_text)

            port = int(port_text)

            if not 1 <= port <= 65535:
                raise ValueError("Invalid port number")

            # Preserve source confidence only when valid
            if (
                isinstance(confidence, bool)
                or not isinstance(confidence, int)
                or not 0 <= confidence <= 100
            ):
                continue

            indicators.append({
                "ip": str(ip),
                "port": port,
                "source": "threatfox",
                "confidence": confidence,
                "threat_type": item.get("threat_type"),
                "first_seen": item.get("first_seen")
            })

        except (ValueError, TypeError):
            print(f"Skipping invalid indicator: {ip_port}")
            continue

    if not indicators:
        print("No valid IP:port indicators found.")

    return indicators
