
/*

select public.udf_ServerTimeToUtc(now()::timestamp)
*/
--select * from util.routines(name:='public.servertime_to_utc');
CALL util.function_drop(name:='public.servertime_to_utc', exceptions:=ARRAY['value timestamp,returns timestamp without time zone']);

CREATE OR REPLACE FUNCTION public.servertime_to_utc
(value timestamp)
RETURNS timestamp
AS $$
BEGIN
  RETURN (value::timestamp with time zone) at time zone 'UTC';
END;
$$ LANGUAGE plpgsql;
