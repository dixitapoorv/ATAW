/*


*/

--select * from util.routines(name:='public.active_providers_sel');
CALL util.function_drop(name:='public.active_providers_sel',exceptions:=ARRAY[
  'property_code varchar(4), OUT property_code varchar(4), OUT provider_id smallint, OUT name varchar(64), OUT provider_type smallint, OUT meta json']);

CREATE OR REPLACE FUNCTION public.active_providers_sel (property_code varchar(4))
RETURNS TABLE(provider_id smallint,property_code varchar, name varchar, provider_type smallint, meta json)
AS $$
  SELECT p.provider_id, p.name, p.property_code, p.provider_type, p.meta
  FROM public.providers p
      INNER JOIN public.provider_types pt ON pt.provider_type = p.provider_type AND pt.active is true
      WHERE p.property_code=active_providers_sel.property_code;
$$ LANGUAGE SQL;

/*
select * from public.active_providers_sel(1);

*/