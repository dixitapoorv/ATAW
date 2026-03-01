CREATE OR REPLACE FUNCTION public.fn_get_categories(
    p_vertical UUID
)
RETURNS TABLE(
    id UUID,
    name TEXT
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT c.id, c.name
    FROM public.category_master c
    WHERE c.vertical_id = p_vertical
      AND c.is_active = TRUE;
END;
$$;