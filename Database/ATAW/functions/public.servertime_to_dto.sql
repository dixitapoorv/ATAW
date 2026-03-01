
/*


*/
--select * from util.routines(name:='public.servertime_to_dto');
CALL util.function_drop(name:='public.servertime_to_dto', exceptions:=ARRAY['value timestamp,returns timestamp with time zone']);

CREATE OR REPLACE FUNCTION public.servertime_to_dto
(value timestamp)
RETURNS timestamp with time zone
AS $$
BEGIN
  RETURN value::timestamp with time zone;
END;
$$ LANGUAGE plpgsql;



