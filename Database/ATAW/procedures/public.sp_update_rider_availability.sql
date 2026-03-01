CREATE OR REPLACE PROCEDURE public.sp_update_rider_availability(
    p_rider UUID,
    p_available BOOLEAN
)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE public.rider_status
    SET is_available = p_available
    WHERE rider_id = p_rider;
END;
$$;