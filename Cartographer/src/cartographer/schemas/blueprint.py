"""
Pydantic schemas for the unified Blueprint endpoint
"""

from pydantic import BaseModel, Field, model_validator
from typing import Optional


class BlueprintRequest(BaseModel):
    name: str = Field(..., description="Person's name")
    year: int = Field(..., ge=1900, le=2100, description="Birth year")
    month: int = Field(..., ge=1, le=12, description="Birth month")
    day: int = Field(..., ge=1, le=31, description="Birth day")
    hour: int = Field(..., ge=0, le=23, description="Birth hour (24h)")
    minute: int = Field(..., ge=0, le=59, description="Birth minute")
    second: int = Field(0, ge=0, le=59, description="Birth second (default 0)")
    place: Optional[str] = Field(None, description="Birth place — geocoded to lat/lon/timezone")
    latitude: Optional[float] = Field(None, ge=-90, le=90, description="Latitude (used when place is not provided)")
    longitude: Optional[float] = Field(None, ge=-180, le=180, description="Longitude (used when place is not provided)")
    timezone: Optional[str] = Field(None, description="IANA timezone string, e.g. 'America/New_York' (used when place is not provided)")
    house_system: str = Field("P", description="House system: P=Placidus, W=Whole Sign, K=Koch, etc.")

    @model_validator(mode="after")
    def require_location(self):
        has_place = self.place is not None
        has_explicit = (
            self.latitude is not None
            and self.longitude is not None
            and self.timezone is not None
        )
        if not has_place and not has_explicit:
            raise ValueError(
                "Provide either 'place' or explicit 'latitude', 'longitude', and 'timezone'."
            )
        return self

    class Config:
        json_schema_extra = {
            "example": {
                "name": "Joe Lewis",
                "year": 1978,
                "month": 9,
                "day": 18,
                "hour": 17,
                "minute": 34,
                "place": "South Williamson, KY, United States"
            }
        }
