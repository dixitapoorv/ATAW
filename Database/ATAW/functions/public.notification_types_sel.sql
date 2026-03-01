/*************************************************************************
DATE          VERSION              NAME                    REFERENCE
2022-04-25    Wallet2.0            Shabina                 WI#593155/593156
Fixed deployement error
*************************************************************************/

--select * from util.routines(name:='public.notification_types_sel');
CALL util.function_drop(name:='public.notification_types_sel',exceptions:=ARRAY[
  'OUT notification_type smallint,OUT name varchar(64), OUT description varchar(256)']);

CREATE OR REPLACE FUNCTION public.notification_types_sel ()
RETURNS TABLE(notification_type smallint, name varchar, description varchar)
AS $$
  SELECT nt.notification_type, nt.name, nt.description
  FROM public.notification_types nt;
$$ LANGUAGE SQL;

/*
select * from public.notification_types_sel;

*/