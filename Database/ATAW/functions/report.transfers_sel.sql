 /**********************************************************************************
DATE        VERSION                    NAME                     REFERENCE
2022-09-22  Wallet2.0                  Shabina                  PBI#390872
Initial Version

2023-01-17  Wallet2.0                  Shabina                  BUG#623584
Passed parameters begin_date_time and  end_date_time

2023-01-24  Wallet2.0                  Shabina                  BUG#623584
Removed parameters begin_date_time and  end_date_time
***********************************************************************************/

CALL util.function_drop(name:='report.transfers_sel',exceptions:=ARRAY[
  'OUT correlation_id uuid, OUT from_provider_name varchar(64), OUT from_property_code varchar(4), OUT to_provider_name varchar(64), OUT to_property_code varchar(4), OUT comment varchar(128),returns record']);

CREATE OR REPLACE FUNCTION report.transfers_sel()
RETURNS TABLE(correlation_id uuid,
      from_provider_name varchar(64),
      from_property_code varchar(4),
      to_provider_name varchar(64),
      to_property_code varchar(4),
      comment varchar(128)      
    )
AS $$
 SELECT t.correlation_id, 
    CASE WHEN r1.provider_type = 1 THEN r1.provider_name
         WHEN r2.provider_type = 1 Then r2.provider_name
         ELSE r1.provider_name
    END from_provider_name ,
    r1.property_code from_property_code,
    CASE WHEN r1.provider_type = 1 THEN r1.provider_name
          WHEN r2.provider_type = 1 Then r2.provider_name
         ELSE r2.provider_name
    END to_provider_name,
    r2.property_code to_property_code,
    t.comment
    FROM public.transfers t
    LEFT JOIN (SELECT case when pt.provider_type =1 THEN pt.name ELSE p.name END provider_name,
               p.property_code, p.provider_id, t.from_wallet_id,pt.provider_type
                FROM public.providers p
                  INNER JOIN public.wallets w ON p.provider_id=w.provider_id
                  INNER JOIN public.provider_types pt ON pt.provider_type = p.provider_type
                  LEFT JOIN public.transfers t on w.wallet_id = t.from_wallet_id
                  GROUP BY pt.provider_type,p.name, p.property_code, p.provider_id, t.from_wallet_id
                  ) r1
    ON r1.from_wallet_id = t.from_wallet_id
    LEFT JOIN (SELECT case when pt.provider_type =1 THEN pt.name ELSE p.name END provider_name,
               p.property_code, p.provider_id, t.to_wallet_id ,pt.provider_type
                FROM public.providers p
                  INNER JOIN public.wallets w ON p.provider_id=w.provider_id
                  INNER JOIN public.provider_types pt ON pt.provider_type = p.provider_type
                  INNER JOIN public.transfers t on w.wallet_id = t.to_wallet_id
                  GROUP BY pt.provider_type,p.name, p.property_code, p.provider_id, t.to_wallet_id
                  ) r2
    ON r2.to_wallet_id = t.to_wallet_id;
$$ LANGUAGE SQL;