def get_threat_indicators():
    indicators = [
        {
            "ip": "203.0.113.10",
            "source": "synthetic",
            "confidence": 90
        },
        {
            "ip": "198.51.100.25",
            "source": "synthetic",
            "confidence": 75
        }
    ]

    return indicators
def count_indicators():
    indicators = get_threat_indicators()
    return len(indicators)