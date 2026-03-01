CREATE OR REPLACE PROCEDURE public.sp_register_user(
    p_id UUID,
    p_full_name TEXT,
    p_phone TEXT,
    p_password TEXT,
    p_role TEXT
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO public.users(id, full_name, phone, password_hash, role)
    VALUES(p_id, p_full_name, p_phone, p_password, p_role);
END;
$$;