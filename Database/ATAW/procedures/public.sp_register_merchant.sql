CREATE OR REPLACE PROCEDURE public.sp_register_merchant(
    p_user UUID,
    p_vertical UUID,
    p_name TEXT,
    p_phone TEXT,
    p_gst TEXT
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO public.merchants(owner_user_id, vertical_id, name, phone, gst_number)
    VALUES(p_user, p_vertical, p_name, p_phone, p_gst);
END;
$$;