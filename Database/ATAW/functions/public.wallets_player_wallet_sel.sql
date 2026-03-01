/*************************************************************************
DATE          VERSION             NAME                    REFERENCE
2022-05-11    Wallet2.0           Shabina                 WI#591529/591522
Replaced provider_id with provider_type in provider_wallet_types table

2022-05-11    Wallet2.0           Shabina                 WI#599635/599706
Added Join condition as provider_players pk is composite (provider_id,player_wallet_id)
*************************************************************************/
CALL util.function_drop(name:='public.wallets_player_wallet_sel',exceptions:=ARRAY[
  'player_wallet_id int,OUT wallet_id int']);

CREATE OR REPLACE FUNCTION public.wallets_player_wallet_sel (player_wallet_id int)
RETURNS TABLE(wallet_id int)
AS $$
  SELECT w.wallet_id
  FROM public.wallets w
      INNER JOIN public.provider_players pp ON w.provider_id = pp.provider_id AND w.player_wallet_id = pp.player_wallet_id
      WHERE pp.player_wallet_id=wallets_player_wallet_sel.player_wallet_id;
$$ LANGUAGE SQL;