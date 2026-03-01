CREATE TABLE public.rider_location (
    rider_id UUID PRIMARY KEY REFERENCES riders(id),
    location GEOGRAPHY(Point,4326),
    updated_at TIMESTAMP DEFAULT NOW()
);
 
CREATE INDEX idx_rider_geo ON public.rider_location USING GIST(location);