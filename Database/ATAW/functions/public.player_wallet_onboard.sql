/*************************************************************************
DATE          VERSION              NAME                    REFERENCE
2022-09-11    Wallet15_0           Shabina                 WI#614160
Initial Version
*************************************************************************/

CALL util.function_drop(name:='public.player_wallet_onboard_sel',exceptions:=ARRAY[
   'begin_date date,end_date date,OUT player_wallet_id int, OUT last_wagering_date date']);

CREATE OR REPLACE FUNCTION public.player_wallet_onboard_sel (begin_date date DEFAULT NULL, end_date date DEFAULT NULL)
RETURNS TABLE(player_wallet_id int, last_wagering_date date)
AS $$
  SELECT pwo.player_wallet_id, pwo.last_wagering_date
  FROM public.player_wallet_onboard pwo
      WHERE (player_wallet_onboard_sel.begin_date IS NULL OR pwo.last_wagering_date >= player_wallet_onboard_sel.begin_date)
      AND (player_wallet_onboard_sel.end_date IS NULL OR pwo.last_wagering_date <= player_wallet_onboard_sel.end_date);
$$ LANGUAGE SQL;