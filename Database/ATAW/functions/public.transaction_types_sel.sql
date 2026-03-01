/*


*/

--select * from util.routines(name:='public.transaction_types_sel');
CALL util.function_drop(name:='public.transaction_types_sel',exceptions:=ARRAY[
  'OUT transaction_type smallint,OUT name varchar(64)']);

CREATE OR REPLACE FUNCTION public.transaction_types_sel()
RETURNS TABLE(transaction_type smallint, name varchar)
AS $$
  SELECT tt.transaction_type, tt.name
  FROM public.transaction_types tt;
$$ LANGUAGE SQL;

/*
select * from public.transaction_types_sel;

*/