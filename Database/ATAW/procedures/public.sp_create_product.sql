CREATE OR REPLACE PROCEDURE public.sp_create_product(
    p_vertical UUID,
    p_category UUID,
    p_subcategory UUID,
    p_name TEXT,
    p_desc TEXT
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO public.product_master(
        vertical_id, category_id, subcategory_id, name, description)
    VALUES(p_vertical, p_category, p_subcategory, p_name, p_desc);
END;
$$;