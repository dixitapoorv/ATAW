/*************************************************************************
DATE          VERSION              NAME                    REFERENCE
2023-03-10    Wallet15_0           Shabina                 WI#634842
Initial Version
*************************************************************************/
CALL util.function_drop(name:='public.check_player_wallet_status',exceptions:=ARRAY[
  'player_wallet_id int4,OUT active bool,returns boolean']);

CREATE OR REPLACE FUNCTION public.check_player_wallet_status(player_wallet_id integer)
RETURNS TABLE(active boolean)
AS $$
  SELECT pw.active
  FROM public.player_wallets pw
  WHERE pw.player_wallet_id=check_player_wallet_status.player_wallet_id;
$$ LANGUAGE SQL;