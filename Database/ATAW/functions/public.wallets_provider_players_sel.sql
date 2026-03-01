/*************************************************************************
DATE          VERSION             NAME                    REFERENCE
2022-05-11    Wallet2.0           Shabina                 WI#591529/591522
Replaced provider_id with provider_type in provider_wallet_types table
*************************************************************************/

--select * from util.routines(name:='public.wallets_provider_players_sel');
CALL util.function_drop(name:='public.wallets_provider_players_sel',exceptions:=ARRAY[
  'wallet_id int,OUT wallet_id int,OUT provider_external_wallet_id varchar,OUT provider_id smallint,OUT provider_external_player_id varchar,OUT wallet_type smallint, OUT provider_type smallint, OUT property_code varchar(4)']);

CREATE OR REPLACE FUNCTION public.wallets_provider_players_sel (wallet_id int)
RETURNS TABLE(wallet_id int, wallet_type smallint, provider_external_wallet_id varchar, provider_id smallint, provider_external_player_id varchar, provider_type smallint, property_code varchar)
AS $$
  SELECT w.wallet_id, w.wallet_type, w.provider_external_wallet_id, pp.provider_id, pp.provider_external_player_id, p.provider_type, p.property_code
  FROM public.wallets w
      INNER JOIN public.provider_players pp ON w.provider_id = pp.provider_id AND w.player_wallet_id = pp.player_wallet_id
      INNER JOIN public.wallet_types wt ON wt.wallet_type = w.wallet_type
      LEFT JOIN public.providers p ON p.provider_id = pp.provider_id
      LEFT JOIN public.provider_wallet_types pwt ON pwt.provider_type = p.provider_type AND pwt.wallet_type = w.wallet_type
      WHERE w.wallet_id=wallets_provider_players_sel.wallet_id;
$$ LANGUAGE SQL;

/*
select * from public.wallets_provider_players_sel(1);

*/