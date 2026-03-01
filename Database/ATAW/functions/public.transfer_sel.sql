/*************************************************************************
DATE          VERSION              NAME                    REFERENCE
2023-03-10    Wallet15_0           Shabina                 WI#634858
Initial Version

2023-03-10    Wallet26_0_0         Abhinav Kant            WI#754961:
Update to add filters for transfer_funds_id and external_transaction_id
*************************************************************************/
CALL util.function_drop(name:='public.transfer_sel',exceptions:=ARRAY[
  'player_wallet_id int4,transfer_funds_ids uuid [],external_transaction_ids varchar(256) [],top int4,skip int4,OUT transfer_id int8,OUT transfer_funds_id uuid,OUT inserted_dto timestamptz,OUT transaction_dto timestamptz,OUT transfer_status int2,OUT from_wallet_id int4,OUT to_wallet_id int4,OUT amount money,OUT comment varchar,OUT meta json,OUT external_transaction_id varchar,OUT transfer_status_name varchar,OUT hash bytea,OUT salt bytea,OUT from_provider_name varchar,OUT from_property_code varchar,OUT to_provider_name varchar,OUT to_property_code varchar,OUT player_wallet_id int4,returns record']);

CREATE OR REPLACE FUNCTION public.transfer_sel(
  player_wallet_id int,
  transfer_funds_ids uuid [] DEFAULT NULL,
  external_transaction_ids varchar(256) [] DEFAULT NULL,
  top int DEFAULT 1024,
  skip int DEFAULT 0)
  RETURNS TABLE(
    transfer_id bigint,
    transfer_funds_id uuid,
    inserted_dto timestamptz,
    transaction_dto timestamptz,
    transfer_status smallint,
    from_wallet_id int,
    to_wallet_id int,
    amount money,
    comment varchar(256),
    meta json,
    external_transaction_id varchar(256),
    transfer_status_name varchar(64),
    hash bytea,
    salt bytea,
    from_provider_name varchar(64),
    from_property_code varchar(4),
    to_provider_name varchar(64),
    to_property_code varchar(4),
    player_wallet_id int)
AS $$
  WITH from_wallet(provider_name,property_code,wallet_id) AS(
    SELECT name provider_name,p.property_code, w.wallet_id
    FROM public.providers p
    INNER JOIN public.wallets w ON p.provider_id=w.provider_id
    GROUP BY name ,p.property_code, p.provider_id, w.wallet_id)
  ,to_wallet (provider_name,property_code,wallet_id) AS(
    SELECT name provider_name,p.property_code, w.wallet_id
    FROM public.providers p
    INNER JOIN public.wallets w ON p.provider_id=w.provider_id
    GROUP BY name,p.property_code, p.provider_id, w.wallet_id)
    SELECT
      t.transfer_id,
      t.correlation_id transfer_funds_id,
      t.inserted_dto,
      t.inserted_dto transaction_dto,
      t.transfer_status,
      t.from_wallet_id,
      t.to_wallet_id,
      t.amount,
      t.comment,
      t.meta,
      t.external_transaction_id,
      ts.name transfer_status_name,
      t.hash,
      t.salt,
      r1.provider_name from_provider_name,
      r1.property_code from_property_code,
      r2.provider_name to_provider_name,
      r2.property_code to_property_code,
      t.player_wallet_id
    FROM public.transfers t
    INNER JOIN public.transfer_statuses ts ON t.transfer_status = ts.transfer_status
    LEFT JOIN from_wallet r1 ON r1.wallet_id = t.from_wallet_id
    LEFT JOIN to_wallet r2 ON r2.wallet_id = t.to_wallet_id
    WHERE (transfer_sel.player_wallet_id IS NULL OR t.player_wallet_id = transfer_sel.player_wallet_id)
      AND (transfer_sel.transfer_funds_ids is NULL OR t.correlation_id = ANY(transfer_sel.transfer_funds_ids))
      AND (transfer_sel.external_transaction_ids is null or t.external_transaction_id = ANY(transfer_sel.external_transaction_ids))
    LIMIT transfer_sel.top OFFSET transfer_sel.skip;
$$ LANGUAGE SQL;