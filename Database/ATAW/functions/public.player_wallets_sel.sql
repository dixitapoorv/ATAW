/*************************************************************************
DATE          VERSION              NAME                    REFERENCE
2022-09-11    Wallet15_0           Shabina                 WI#614160
Returned columns wagering_account_status and last_wagering_date
*************************************************************************/

CALL util.function_drop(name:='public.player_wallets_sel',exceptions:=ARRAY[
  'player_wallet_id int, begin_date date,end_date date,OUT player_wallet_id int, OUT active boolean, OUT player_application_id varchar(64), OUT last_wagering_date date,OUT wagering_account_status boolean']);

CREATE OR REPLACE FUNCTION public.player_wallets_sel (player_wallet_id int DEFAULT NULL, begin_date date DEFAULT NULL, end_date date DEFAULT NULL)
RETURNS TABLE(player_wallet_id int, active boolean, player_application_id varchar, last_wagering_date date, wagering_account_status boolean)
AS $$
  SELECT pw.player_wallet_id, pw.active, pw.player_application_id, pw.last_wagering_date, pw.wagering_account_status
  FROM public.player_wallets pw
      WHERE (player_wallets_sel.player_wallet_id IS NULL OR pw.player_wallet_id = player_wallets_sel.player_wallet_id)
      AND (player_wallets_sel.begin_date IS NULL OR pw.last_wagering_date >= player_wallets_sel.begin_date)
      AND (player_wallets_sel.end_date IS NULL OR pw.last_wagering_date <= player_wallets_sel.end_date);
$$ LANGUAGE SQL;