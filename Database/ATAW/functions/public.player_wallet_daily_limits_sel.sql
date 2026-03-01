/*


*/

--select * from util.routines(name:='public.player_wallet_daily_limits_sel');
CALL util.function_drop(name:='public.player_wallet_daily_limits_sel',exceptions:=ARRAY[
  'player_wallet_id int,OUT limit_amount money, OUT inserted_dto timestamptz, OUT daily_transfer_amount money']);

CREATE OR REPLACE FUNCTION public.player_wallet_daily_limits_sel (player_wallet_id int DEFAULT NULL)
RETURNS TABLE(player_wallet_id int, limit_amount money, inserted_dto timestamptz, daily_transfer_amount money )
AS $$
  SELECT player_wallet_id, limit_amount, inserted_dto, daily_transfer_amount
  FROM(
     SELECT dl.player_wallet_id, dl.limit_amount, dl.inserted_dto, dt.daily_transfer_amount,
           ROW_NUMBER() OVER (PARTITION BY dl.player_wallet_id ORDER BY dl.inserted_dto DESC) AS RN
     FROM public.player_wallet_daily_limits dl
     LEFT JOIN public.player_wallet_daily_transfers dt ON dl.player_wallet_id = dt.player_wallet_id
     WHERE player_wallet_daily_limits_sel.player_wallet_id IS NULL OR dl.player_wallet_id =  player_wallet_daily_limits_sel.player_wallet_id
     ) result_set
     WHERE result_set.RN = 1
$$ LANGUAGE SQL;

/*
select * from public.player_wallet_daily_limits_sel(1);

*/