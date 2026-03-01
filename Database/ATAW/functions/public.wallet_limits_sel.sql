/*


*/

--select * from util.routines(name:='public.wallet_limits_sel');
CALL util.function_drop(name:='public.wallet_limits_sel',exceptions:=ARRAY[
  'wallet_id int,OUT amount money,OUT wallet_id int,OUT daily_transfer_date date,OUT expiration_datetime timestamp']);

CREATE OR REPLACE FUNCTION public.wallet_limits_sel (wallet_id int)
RETURNS TABLE(amount money, wallet_id int, daily_transfer_date date, expiration_datetime timestamp)
AS $$
  SELECT wl.amount, wl.wallet_id, wl.daily_transfer_date, wl.expiration_datetime
  FROM public.wallet_limits wl
  WHERE wallet_limits_sel.wallet_id = wl.wallet_id
$$ LANGUAGE SQL;

/*
select * from public.wallet_limits_sel(1);
select * from public.wallet_limits;
*/