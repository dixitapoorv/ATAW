CREATE OR REPLACE PROCEDURE public.sp_create_order(
    p_order UUID,
    p_customer UUID,
    p_merchant UUID,
    p_vertical UUID,
    p_total NUMERIC
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO public.orders(
        id, customer_user_id, merchant_id,
        vertical_id, total_amount, status)
    VALUES(p_order, p_customer, p_merchant,
           p_vertical, p_total, 0);
END;
$$;