from fastapi import (
    FastAPI,  #it imports the FastAPI Class from the fastapi package
    HTTPException,
)

from app.collector.deduplicator import remove_duplicates

app = FastAPI()
@app.get("/health", tags=["Health Check"])
def health():
    return { "status": "healthy", "service": "Azure-threatshield"}
from app.collector.threatfox import fetch_threatfox_indicators


@app.get("/indicators/live", tags=["live_from_threatfox"])
def live_indicators():
    try:
        indicators = fetch_threatfox_indicators()

        return {
            "total_count": len(indicators),
            "indicators": indicators
        }

    except Exception:
        raise HTTPException(
            status_code=503,
            detail="ThreatFox API is currently unavailable"
        )

from app.collector.validator import is_valid_public_ip


@app.get("/indicators/validated", tags=["Validated IPs"])
def validated_indicators():
    try:
        indicators = fetch_threatfox_indicators()

        valid_indicators = []

        for indicator in indicators:
            if is_valid_public_ip(indicator["ip"]):
                valid_indicators.append(indicator)
        unique_indicators = remove_duplicates(valid_indicators)
        return {
            "total_count": len(unique_indicators),
            "duplicates_removed": len(valid_indicators) - len(unique_indicators),
            "indicators": unique_indicators
            }

    except Exception:
        raise HTTPException(
            status_code=503,
            detail="ThreatFox indicators could not be processed"
        )