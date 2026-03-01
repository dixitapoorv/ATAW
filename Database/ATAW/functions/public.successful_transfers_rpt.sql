/*************************************************************************
DATE          VERSION              NAME                    REFERENCE
2022-04-25    Wallet2.0            Shabina                 WI#592011/593650
converted hash and salt to bytea
*************************************************************************/

--select * from util.routines(name:='public.successful_transfers_rpt');
CALL util.function_drop(name:='public.successful_transfers_rpt',exceptions:=ARRAY[
  'wallet_id int,OUT transfer_lineitem_id varchar(256), OUT transfer_funds_id uuid,OUT transfer_lineitem_guid uuid, OUT wallet_id int, OUT transaction_type smallint, OUT completed_dto timestamptz,OUT failed boolean,OUT amount money, OUT comment varchar(256), OUT external_transaction_id varchar(256), OUT meta json, OUT hash bytea, OUT salt bytea']);

CREATE OR REPLACE FUNCTION public.successful_transfers_rpt (wallet_id int)
RETURNS TABLE(transfer_lineitem_id varchar, transfer_funds_id uuid, transfer_lineitem_guid uuid, wallet_id int, transaction_type smallint, completed_dto timestamptz, failed boolean, amount money, comment varchar, external_transaction_id varchar, meta json, hash bytea, salt bytea)
AS $$
 -- DECLARE day_start timestamptz, day_end timestamptz;
  SELECT tli.transfer_lineitem_id, tli.transfer_funds_id, tli.transfer_lineitem_guid, tli.wallet_id, tli.transaction_type, tli.completed_dto, tli.failed,
         tli.amount, tli.comment, tli.external_transaction_id,tli.meta, tli.hash, tli.salt
  FROM public.transfer_history ts
      INNER JOIN public.transfer_lineitems tli ON tli.transfer_funds_id = ts.transfer_funds_id
      INNER JOIN public.transfer_history tsc ON ts.transfer_funds_id = tsc.transfer_funds_id
  WHERE ts.from_wallet_id = successful_transfers_rpt.wallet_id
        AND ts.transfer_status = 6
        AND tli.transaction_type = 2 -- for withdraw
        AND tsc.transfer_status = 10;
$$ LANGUAGE SQL;

/*
select * from public.successful_transfers_rpt(1);

*/