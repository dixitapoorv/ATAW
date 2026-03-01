CREATE OR REPLACE PROCEDURE public.sp_create_subcategory(
    p_category UUID,
    p_name TEXT
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO public.subcategory_master(category_id, name)
    VALUES(p_category, p_name);
END;
$$;