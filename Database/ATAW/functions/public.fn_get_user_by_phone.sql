CREATE OR REPLACE FUNCTION public.fn_get_user_by_phone(p_phone TEXT)
RETURNS TABLE(
    id UUID,
    full_name TEXT,
    phone TEXT,
    password_hash TEXT,
    role TEXT
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT u.id, u.full_name, u.phone, u.password_hash, u.role
    FROM public.users u
    WHERE u.phone = p_phone AND u.is_active = TRUE;
END;
$$;