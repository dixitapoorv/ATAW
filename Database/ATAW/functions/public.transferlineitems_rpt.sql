/*************************************************************************
DATE          VERSION              NAME                    REFERENCE
2022-04-25    Wallet2.0            Shabina                 WI#592011/593650
converted hash and salt to bytea
*************************************************************************/
--CALL util.function_drop(name:='public.transferlineitems_rpt');
--select * from util.routines(name:='public.transferlineitems_rpt');
CALL util.function_drop(name:='public.transferlineitems_rpt',exceptions:=ARRAY[
  'player_wallet_id int4,transfer_funds_id uuid,transfer_status int2,external_transaction_id varchar,transfers bool,transactions bool,top int4,skip int4,OUT transfer_lineitem_id varchar,OUT transfer_lineitem_guid uuid,OUT transfer_funds_id uuid,OUT wallet_id int4,OUT transaction_type int2,OUT completed_dto timestamptz,OUT failed boolean,OUT meta json,OUT amount money,OUT comment varchar,OUT external_transaction_id varchar,OUT hash bytea,OUT salt bytea,OUT total_count bigint,returns record'
]);

CREATE OR REPLACE FUNCTION public.transferlineitems_rpt (
  player_wallet_id int,
  transfer_funds_id uuid DEFAULT NULL,
  transfer_status smallint DEFAULT 0::smallint,
  external_transaction_id varchar(256) DEFAULT NULL,
  transfers boolean DEFAULT FALSE,
  transactions boolean DEFAULT FALSE,
  top int DEFAULT 1024,
  skip int DEFAULT 0)
RETURNS TABLE(
  transfer_lineitem_id varchar(256),
  transfer_lineitem_guid uuid,
  transfer_funds_id uuid,
  wallet_id int,
  transaction_type smallint,
  completed_dto timestamptz,
  failed boolean,
  meta json,
  amount money,
  comment varchar(256),
  external_transaction_id varchar(256),
  hash bytea,
  salt bytea,
  total_count bigint
)
AS $$
  SELECT
    li.transfer_lineitem_id, li.transfer_lineitem_guid,li.transfer_funds_id, li.wallet_id, li.transaction_type,
    li.completed_dto, li.failed, li.meta, li.amount, li.comment, li.external_transaction_id, li.hash, li.salt, count(1) OVER () total_count
  FROM public.transfer_rpt (
      player_wallet_id, transfer_funds_id, transfer_status, external_transaction_id,
      transfers,  transactions, top, skip) t
    INNER JOIN public.transfer_lineitems li on t.transfer_funds_id=li.transfer_funds_id
  ORDER BY t.transfer_funds_id;
$$ LANGUAGE SQL;
