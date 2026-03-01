/*************************************************************************
DATE          VERSION             NAME                    REFERENCE
2022-05-11    Wallet2.0           Shabina                 WI#591529/591522
Replaced provider_id with provider_type in provider_wallet_types table

2022-11-15....Wallwt15-0         Shabina                 WI#616181
Returned wagering_account_status and last_wagering_date columns
*************************************************************************/

--select * from util.routines(name:='public.player_wallets_providers_sel');
CALL util.function_drop(name:='public.player_wallets_providers_sel',exceptions:=ARRAY[
  'player_application_id varchar(64), property_code varchar(4),OUT player_wallet_id int, OUT active boolean, OUT player_application_id varchar(64), OUT provider_id smallint, OUT provider_external_player_id varchar(64), OUT global_player_id varchar(64),OUT wallet_id int, OUT provider_external_wallet_id varchar(64), OUT wallet_type smallint, OUT meta json, OUT provider_wallet_type smallint, OUT wallet_limit_id int, OUT amount money, OUT expiration_datetime timestamp, OUT provider_name varchar(64), OUT provider_type smallint, OUT property_code varchar(4), OUT is_dirty boolean']);

CREATE OR REPLACE FUNCTION public.player_wallets_providers_sel (
  player_application_id varchar(64) DEFAULT NULL,
  property_code varchar(4) DEFAULT NULL,
  player_wallet_id int DEFAULT NULL)
RETURNS TABLE(
  player_wallet_id int,
  active boolean,
  player_application_id varchar,
  provider_id smallint,
  provider_external_player_id varchar,
  global_player_id varchar,
  wallet_id int,
  provider_external_wallet_id varchar,
  wallet_type smallint,
  meta json,
  provider_wallet_type smallint,
  wallet_limit_id int,
  amount money,
  expiration_datetime timestamp,
  provider_name varchar,
  provider_type smallint,
  property_code varchar,
  is_dirty boolean,
  wagering_account_status boolean,
  last_wagering_date date
)
AS $$
  SELECT pw.player_wallet_id, pw.active, pw.player_application_id, pp.provider_id, pp.provider_external_player_id, pp.global_player_id,
    w.wallet_id, w.provider_external_wallet_id, w.wallet_type, w.meta, pwt.wallet_type provider_wallet_type, wl.wallet_limit_id, wl.amount,
    wl.expiration_datetime, p.name provider_name, p.provider_type, p.property_code, w.is_dirty, pw.wagering_account_status, pw.last_wagering_date
  FROM public.player_wallets pw
    LEFT JOIN
    ( SELECT ppl.player_wallet_id, ppl.provider_id, ppl.provider_external_player_id,ppl.global_player_id
      FROM public.provider_players ppl
        INNER JOIN public.providers pvd ON ppl.provider_id = pvd.provider_id
      WHERE player_wallets_providers_sel.property_code IS NULL OR pvd.property_code = player_wallets_providers_sel.property_code ) pp
    ON pw.player_wallet_id = pp.player_wallet_id
    LEFT JOIN public.wallets w ON w.provider_id = pp.provider_id AND w.player_wallet_id = pp.player_wallet_id
    LEFT JOIN public.providers p ON p.provider_id = pp.provider_id
    LEFT JOIN public.provider_wallet_types pwt ON pwt.provider_type = p.provider_type AND pwt.wallet_type = w.wallet_type
    LEFT JOIN public.wallet_limits wl ON wl.wallet_id = w.wallet_id
  WHERE (player_wallets_providers_sel.player_application_id IS NULL OR pw.player_application_id = player_wallets_providers_sel.player_application_id)
      AND (player_wallets_providers_sel.property_code IS NULL OR p.property_code IS NULL OR p.property_code = player_wallets_providers_sel.property_code)
      AND (player_wallets_providers_sel.player_wallet_id IS NULL OR pw.player_wallet_id = player_wallets_providers_sel.player_wallet_id)

$$ LANGUAGE SQL;

/*
select * from public.player_wallets_providers_sel(1);

*/