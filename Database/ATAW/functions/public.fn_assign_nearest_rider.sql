CREATE OR REPLACE FUNCTION public.fn_assign_nearest_rider(
    p_lat DOUBLE PRECISION,
    p_lng DOUBLE PRECISION
)
RETURNS UUID
LANGUAGE plpgsql
AS $$
DECLARE v_rider UUID;
BEGIN
    SELECT r.id INTO v_rider
    FROM public.riders r
    JOIN public.rider_status s ON r.id = s.rider_id
    JOIN public.rider_location l ON r.id = l.rider_id
    WHERE s.is_available = TRUE
    ORDER BY l.location <-> ST_SetSRID(ST_MakePoint(p_lng, p_lat), 4326)
    LIMIT 1;
 
    RETURN v_rider;
END;
$$;