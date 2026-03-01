/*


*/

--select * from util.routines(name:='public.transfer_statuses_sel');
CALL util.function_drop(name:='public.transfer_statuses_sel',exceptions:=ARRAY[
  'OUT transfer_status smallint,OUT name varchar(64)']);

CREATE OR REPLACE FUNCTION public.transfer_statuses_sel (transfer_status smallint)
RETURNS TABLE(transfer_status smallint, name varchar)
AS $$
  SELECT ts.transfer_status, ts.name
  FROM public.transfer_statuses ts
  WHERE ts.transfer_status = transfer_statuses_sel.transfer_status;
$$ LANGUAGE SQL;

/*
select * from public.transfer_statuses_sel(1);

*/