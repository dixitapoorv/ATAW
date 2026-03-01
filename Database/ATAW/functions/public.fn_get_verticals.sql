CREATE OR REPLACE FUNCTION public.fn_get_verticals()
RETURNS TABLE(id UUID, name TEXT, code TEXT)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT v.id, v.name, v.code
    FROM public.service_vertical_master v
    WHERE v.is_active = TRUE;
END;
$$;