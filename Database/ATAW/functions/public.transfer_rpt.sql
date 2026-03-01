/*************************************************************************
DATE          VERSION              NAME                    REFERENCE
2022-04-25    Wallet2.0            Shabina                 WI#592011/593650
converted hash and salt to bytea

2022-07-01    Wallet2.0            Shabina                 WI#594350/598106
Returned player_wallet_id, provider name and property code

2022-07-18    Wallet2.0            Shabina                 WI#594350/598106
Returned data when wallets are null
*************************************************************************/
CALL util.function_drop(name:='public.transfer_rpt',exceptions:=ARRAY[
  'player_wallet_id int4,transfer_funds_id uuid,transfer_status smallint,external_transaction_id varchar,transfers boolean,transactions boolean,top int,skip int,OUT transfer_id bigint,OUT transfer_funds_id uuid,OUT inserted_dto timestamptz,OUT transaction_dto timestamptz,OUT transfer_status smallint,OUT from_wallet_id int,OUT to_wallet_id int,OUT amount money,OUT comment varchar,OUT meta json,OUT external_transaction_id varchar,OUT transfer_status_name varchar,OUT hash bytea,OUT salt bytea,OUT total_count bigint,returns record'
]);

CREATE OR REPLACE FUNCTION public.transfer_rpt(
    player_wallet_id int,
    transfer_funds_id uuid DEFAULT NULL,
    transfer_status smallint DEFAULT 0::smallint,
    external_transaction_id varchar(256) DEFAULT NULL,
    transfers boolean DEFAULT false,
    transactions boolean DEFAULT false,
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
      player_wallet_id int,
      total_count bigint) 
AS $$
  SELECT
    rs.transfer_id,
    rs.transfer_funds_id,
    rs.inserted_dto,
    rs.transaction_dto,
    rs.transfer_status,
    rs.from_wallet_id,
    rs.to_wallet_id,
    rs.amount,
    rs.comment,
    rs.meta,
    rs.external_transaction_id,
    rs.transfer_status_name,
    rs.hash,
    rs.salt,
    rs.from_provider_name,
    rs.from_property_code,
    rs.to_provider_name,
    rs.to_property_code,
    rs.player_wallet_id,
    rs.total_count
  FROM(
    SELECT 
      trs.transfer_id,
      t.transfer_funds_id,
      t.inserted_dto,
      t.transaction_dto,
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
      pp.player_wallet_id,
      count(1) OVER () total_count, ROW_NUMBER() OVER (PARTITION BY t.transfer_funds_id ORDER BY t.inserted_dto DESC) AS RN
      FROM public.provider_players pp
        INNER JOIN public.wallets w ON pp.provider_id=w.provider_id and pp.player_wallet_id=w.player_wallet_id
        INNER JOIN public.transfer_history t on w.wallet_id = t.from_wallet_id OR w.wallet_id=t.to_wallet_id
        INNER JOIN public.transfer_statuses ts on ts.transfer_status=t.transfer_status
        INNER JOIN public.transfers trs ON trs.correlation_id = t.transfer_funds_id
        LEFT JOIN (SELECT DISTINCT name provider_name,property_code, p.provider_id, t.from_wallet_id 
                    FROM public.providers p
                      INNER JOIN public.wallets w ON p.provider_id=w.provider_id
                      LEFT JOIN public.transfer_history t on w.wallet_id = t.from_wallet_id) r1
        ON r1.from_wallet_id = t.from_wallet_id
        LEFT JOIN (SELECT DISTINCT name provider_name,property_code, p.provider_id, t.to_wallet_id 
                    FROM public.providers p
                      INNER JOIN public.wallets w ON p.provider_id=w.provider_id
                      INNER JOIN public.transfer_history t on w.wallet_id = t.to_wallet_id) r2
        ON r2.to_wallet_id = t.to_wallet_id
      WHERE (transfer_rpt.player_wallet_id IS NULL OR pp.player_wallet_id = transfer_rpt.player_wallet_id)
        AND (transfer_rpt.transfer_funds_id is NULL OR transfer_rpt.transfer_funds_id=t.transfer_funds_id)
        AND (transfer_rpt.transfer_status =0::smallint OR transfer_rpt.transfer_status=t.transfer_status)
        AND (transfer_rpt.external_transaction_id is null or transfer_rpt.external_transaction_id=t.external_transaction_id)
        AND (
          (transfer_rpt.transfers = false AND  transfer_rpt.transactions= false)
          OR (transfer_rpt.transfers = true AND  transfer_rpt.transactions= true)
          OR (transfer_rpt.transfers = true AND transfer_rpt.transactions = false AND t.from_wallet_id  IS NOT NULL AND t.to_wallet_id  IS NOT NULL)
          OR (transfer_rpt.transfers = false AND transfer_rpt.transactions = true AND (t.from_wallet_id  IS NULL OR t.to_wallet_id IS NULL))
        )
        LIMIT transfer_rpt.top OFFSET transfer_rpt.skip
        )rs
  WHERE rs.RN = 1;
$$ LANGUAGE SQL;
