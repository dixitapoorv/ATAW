CREATE OR REPLACE PROCEDURE public.sp_create_vertical(p_name TEXT, p_code TEXT)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO public.service_vertical_master(name, code)
    VALUES(p_name, p_code);
END;
$$;