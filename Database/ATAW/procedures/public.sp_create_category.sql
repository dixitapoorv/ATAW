CREATE OR REPLACE PROCEDURE public.sp_create_category(
    p_vertical UUID,
    p_name TEXT
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO public.category_master(vertical_id, name)
    VALUES(p_vertical, p_name);
END;
$$;