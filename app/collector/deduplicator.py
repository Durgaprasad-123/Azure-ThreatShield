def remove_duplicates(indicators):
    unique = []
    seen = set()
    for indicator in indicators:
        key=(
            indicator["ip"],
            indicator["port"],
            indicator["source"],
            indicator["threat_type"]
        )
        if key not in seen:
            seen.add(key)
            unique.append(indicator)
    return unique