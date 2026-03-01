/*************************************************************************
DATE          VERSION             NAME                    REFERENCE
2022-05-11    Wallet2.0           Shabina                 WI#591529/591522
Replaced provider_id with provider_type in provider_wallet_types table
*************************************************************************/

--select * from util.routines(name:='public.wallet_types_provider_wallet_types_sel');
CALL util.function_drop(name:='public.wallet_types_provider_wallet_types_sel',exceptions:=ARRAY[
  'provider_type smallint,OUT wallet_type smallint, OUT wallet_type_name varchar(64), OUT provider_wallet_type_name varchar(64)']);

CREATE OR REPLACE FUNCTION public.wallet_types_provider_wallet_types_sel (provider_type smallint)
RETURNS TABLE(wallet_type smallint, wallet_type_name varchar, provider_wallet_type_name varchar)
AS $$
  SELECT wt.wallet_type, wt.name wallet_type_name, pwt.alias provider_wallet_type_name
  FROM public.wallet_types wt
      INNER JOIN public.provider_wallet_types pwt ON pwt.wallet_type = wt.wallet_type
      WHERE pwt.provider_type=wallet_types_provider_wallet_types_sel.provider_type;
$$ LANGUAGE SQL;

/*
select * from public.wallet_types_provider_wallet_types_sel(1);

*/