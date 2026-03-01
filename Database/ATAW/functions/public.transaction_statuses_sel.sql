/*


*/

--select * from util.routines(name:='public.transaction_statuses_sel');
CALL util.function_drop(name:='public.transaction_statuses_sel',exceptions:=ARRAY[
  'OUT transaction_status smallint,OUT name varchar(64)']);

CREATE OR REPLACE FUNCTION public.transaction_statuses_sel (transaction_status smallint)
RETURNS TABLE(transaction_status smallint, name varchar)
AS $$
  SELECT ts.transaction_status, ts.name
  FROM public.transaction_statuses ts
  WHERE ts.transaction_status = transaction_statuses_sel.transaction_status;
$$ LANGUAGE SQL;

/*
select * from public.transaction_statuses_sel(1);

*/