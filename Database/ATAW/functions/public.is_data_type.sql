
/*

select public.udf_IsDataType('test','text'), public.udf_IsDataType('test','int'), public.udf_IsDataType('1','int');
*/
--select * from util.routines(name:='public.is_data_type');
CALL util.function_drop(name:='public.is_data_type', exceptions:=ARRAY['value text,datatype varchar,returns boolean']);

CREATE OR REPLACE FUNCTION public.is_data_type
(
  value text, 
  dataType varchar(32)
)
RETURNS boolean
AS $$
BEGIN
  BEGIN
    RETURN CASE dataType
      WHEN 'boolean' THEN coalesce(value::boolean::text,'null') = coalesce(value,'null')
      WHEN 'smallint' THEN coalesce(value::smallint::text,'null') = coalesce(value,'null')
      WHEN 'int' THEN coalesce(value::int::text,'null') = coalesce(value,'null')
      WHEN 'bigint' THEN coalesce(value::bigint::text,'null') = coalesce(value,'null')
      WHEN 'numeric' THEN coalesce(value::numeric::text,'null') = coalesce(value,'null')
      WHEN 'date' THEN coalesce(value::date::text,'null') = coalesce(value,'null')
      WHEN 'time' THEN coalesce(value::time::text,'null') = coalesce(value,'null')
      WHEN 'time with time zone' THEN coalesce(value::time with time zone::text,'null') = coalesce(value,'null')
      WHEN 'timestamp' THEN coalesce(value::timestamp::text,'null') = coalesce(value,'null')
      WHEN 'timestamp with time zone' THEN coalesce(value::timestamp with time zone::text,'null') = coalesce(value,'null')
      WHEN 'text' THEN coalesce(trim(value),'null') = coalesce(value,'null')
      WHEN 'char' THEN coalesce(trim(value),'null') = coalesce(value,'null')
      WHEN 'varchar' THEN coalesce(trim(value),'null') = coalesce(value,'null')
      WHEN 'json' THEN coalesce(value::json::text,'null') = coalesce(value,'null')
      WHEN 'uuid' THEN coalesce(value::uuid::text,'null') = coalesce(value,'null')

      -- imprecise conversions
      WHEN 'money' THEN replace(value::money::text,'$','') != ''
      WHEN 'real' THEN value::real::text != ''

      -- array types
      WHEN 'array<smallint>' THEN NOT EXISTS(SELECT 1 from unnest(string_to_array(value,',')) where not public.is_data_type(unnest,'smallint'))
      WHEN 'array<int>' THEN NOT EXISTS(SELECT 1 from unnest(string_to_array(value,',')) where not public.is_data_type(unnest,'int'))
      WHEN 'array<bigint>' THEN NOT EXISTS(SELECT 1 from unnest(string_to_array(value,',')) where not public.is_data_type(unnest,'bigint'))
      WHEN 'array<numeric>' THEN NOT EXISTS(SELECT 1 from unnest(string_to_array(value,',')) where not public.is_data_type(unnest,'numeric'))
      WHEN 'array<text>' THEN NOT EXISTS(SELECT 1 from unnest(string_to_array(value,',')) where not public.is_data_type(unnest,'text'))
      WHEN 'array<char>' THEN NOT EXISTS(SELECT 1 from unnest(string_to_array(value,',')) where not public.is_data_type(unnest,'char'))
      WHEN 'array<varchar>' THEN NOT EXISTS(SELECT 1 from unnest(string_to_array(value,',')) where not public.is_data_type(unnest,'varchar'))
      WHEN 'array<uuid>' THEN NOT EXISTS(SELECT 1 from unnest(string_to_array(value,',')) where not public.is_data_type(unnest,'uuid'))

      -- can't check unkown types
      ELSE NULL
    END;

  EXCEPTION WHEN OTHERS THEN
    RETURN false;
  END;

END;
$$ LANGUAGE plpgsql;
