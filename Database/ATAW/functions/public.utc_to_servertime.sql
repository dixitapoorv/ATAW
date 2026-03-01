
/*


select public.udf_ServerTimeToUtc(now()::timestamp), public.udf_UTCToServerTime(public.udf_ServerTimeToUtc(now()::timestamp))
*/
--select * from util.routines(name:='public.utc_to_servertime');
CALL util.function_drop(name:='public.utc_to_servertime', exceptions:=ARRAY['value timestamp,returns timestamp without time zone']);

CREATE OR REPLACE FUNCTION public.utc_to_servertime
(value timestamp)
RETURNS timestamp
AS $$
BEGIN 
  RETURN (value at time zone 'UTC')::timestamp;
END;
$$ LANGUAGE plpgsql;
