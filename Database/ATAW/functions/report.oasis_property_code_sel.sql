 /**********************************************************************************
DATE        VERSION                    NAME                     REFERENCE
2022-09-09  Wallet2.0                  Shabina                  PBI#390872
Initial Version
***********************************************************************************/

CALL util.function_drop(name:='report.oasis_property_code_sel',exceptions:=ARRAY[
  'OUT property_code varchar(4), OUT provider_name varchar(64)']);

CREATE OR REPLACE FUNCTION report.oasis_property_code_sel()
RETURNS TABLE(property_code varchar, provider_name varchar)
AS $$
  SELECT p.property_code, p.name provider_name
  FROM public.providers p
  WHERE provider_type in (
  SELECT provider_type FROM public.provider_types WHERE name = 'Oasis')
  ORDER BY p.name;
$$ LANGUAGE SQL;