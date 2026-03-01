/*


*/

--select * from util.routines(name:='public.player_wallet_daily_transfers_sel');
CALL util.function_drop(name:='public.player_wallet_daily_transfers_sel',exceptions:=ARRAY[
  'player_wallet_id int,OUT player_wallet_id int,OUT daily_transfer_amount money, OUT updated_dto timestamptz']);

CREATE OR REPLACE FUNCTION public.player_wallet_daily_transfers_sel (player_wallet_id int DEFAULT NULL)
RETURNS TABLE(player_wallet_id int, daily_transfer_amount money, updated_dto timestamptz )
AS $$
  SELECT dt.player_wallet_id, dt.daily_transfer_amount, dt.updated_dto
  FROM public.player_wallet_daily_transfers dt
  WHERE player_wallet_daily_transfers_sel.player_wallet_id IS NULL OR dt.player_wallet_id =  player_wallet_daily_transfers_sel.player_wallet_id

$$ LANGUAGE SQL;

/*
select * from public.player_wallet_daily_transfers_sel(1);

*/