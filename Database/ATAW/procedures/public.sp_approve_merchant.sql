CREATE OR REPLACE PROCEDURE public.sp_approve_merchant(
    p_merchant UUID,
    p_approve BOOLEAN
)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE public.merchants
    SET is_approved = p_approve,
        status = CASE WHEN p_approve THEN 1 ELSE 2 END
    WHERE id = p_merchant;
END;
$$;