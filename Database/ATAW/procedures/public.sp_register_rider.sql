CREATE OR REPLACE PROCEDURE public.sp_register_rider(
    p_id UUID,
    p_user UUID,
    p_license TEXT
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO public.riders(id, user_id, driving_license)
    VALUES(p_id, p_user, p_license);
 
    INSERT INTO public.rider_status(rider_id, is_available)
    VALUES(p_id, FALSE);
END;
$$;