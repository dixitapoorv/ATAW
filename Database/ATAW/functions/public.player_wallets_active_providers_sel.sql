/*************************************************************************
DATE          VERSION             NAME                    REFERENCE
2022-06-27    Wallet2.0           Shabina                 PBI#554444/WI#597767
Initial Version

2024-02-08    Wallet15.2           Shabina                 Defect#672487/WI#672488
Replaced filter from provider_id to provider_type 
*************************************************************************/
CALL util.function_drop(name:='public.player_wallets_active_providers_sel',exceptions:=ARRAY[
  'external_provider_id int, internal_provider_id int, OUT global_player_id varchar(64), OUT player_wallet_id']);

CREATE OR REPLACE FUNCTION public.player_wallets_active_providers_sel(
  external_provider_id int,
  internal_provider_id int)
RETURNS TABLE(player_wallet_id int)
AS $$
  SELECT w.player_wallet_id
  FROM public.wallets w
    LEFT JOIN public.providers p ON p.provider_id = w.provider_id
    LEFT JOIN public.provider_types pt ON p.provider_type = pt.provider_type
  WHERE (p.provider_type = external_provider_id OR p.provider_type = internal_provider_id)
  GROUP BY w.player_wallet_id;
$$ LANGUAGE SQL;