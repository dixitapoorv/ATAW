CREATE OR REPLACE PROCEDURE public.sp_update_rider_location(
    p_rider UUID,
    p_lat DOUBLE PRECISION,
    p_lng DOUBLE PRECISION
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO public.rider_location(rider_id, location)
    VALUES(p_rider, ST_SetSRID(ST_MakePoint(p_lng, p_lat), 4326))
    ON CONFLICT (rider_id)
    DO UPDATE SET location = EXCLUDED.location,
                  updated_at = NOW();
END;
$$;