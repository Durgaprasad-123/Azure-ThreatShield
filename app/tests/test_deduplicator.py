from app.collector.deduplicator import remove_duplicates


def test_duplicate_indicators():
    indicators = [
        {
            "ip":"8.8.8.8",
            "port" : 443,
            "source":"test",
            "threat_type":"demo"
        },
        {
            "ip":"8.8.8.8",
            "port": 443,
            "source":"test",
            "threat_type":"demo"
        }
    ]
    result = remove_duplicates(indicators)
    assert len(result) == 1