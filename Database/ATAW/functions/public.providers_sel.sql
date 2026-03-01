/*************************************************************************************
DATE        VERSION     AUTHOR         REFERENCE
2022-06-16  Wallet2.0   Shabina Bano   PBI#575837/596401
Added Input Param property_code

2023-01-11  Wallet2.0   Shabina Bano   PBI#624282
Returned provider_name
**************************************************************************************/

CALL util.function_drop(name:='public.providers_sel',exceptions:=ARRAY[
  'provider_type smallint, OUT provider_id smallint, OUT property_code varchar(4),returns record']);

CREATE OR REPLACE FUNCTION public.providers_sel (provider_type smallint DEFAULT NULL, property_code varchar(4) DEFAULT NULL)
RETURNS TABLE(provider_id smallint, provider_name varchar(64), property_code varchar, meta json)
AS $$
  SELECT p.provider_id, p.name provider_name, p.property_code, p.meta
  FROM public.providers p
  WHERE (providers_sel.provider_type IS NULL OR p.provider_type = providers_sel.provider_type)
  AND (providers_sel.property_code IS NULL OR p.property_code = providers_sel.property_code)
$$ LANGUAGE SQL;