/*************************************************************************
DATE          VERSION              NAME                    REFERENCE
2022-08-22    Wallet2.0            Shabina                 WI#603371
Initial Version
*************************************************************************/

CALL util.function_drop(name:='public.account_update_status_sel',exceptions:=ARRAY[
  'request_id uuid,player_wallet_id int, OUT request_id uuid, OUT provider_request_id uuid,OUT request_payload_json json, OUT successful boolean,OUT message varchar(512), OUT property_code varchar(4),returns record']);

CREATE OR REPLACE FUNCTION public.account_update_status_sel (
  request_id uuid DEFAULT NULL,
  player_wallet_id int DEFAULT NULL)
RETURNS TABLE(
  request_id uuid,
  provider_request_id uuid,
  request_payload_json json,
  successful boolean,
  message varchar(512),
  property_code varchar(4)
)
AS $$
  SELECT request_id,provider_request_id,request_payload_json,successful,message,property_code
  FROM public.account_update_status
  WHERE (account_update_status_sel.request_id IS NULL OR request_id = account_update_status_sel.request_id)
  AND (account_update_status_sel.player_wallet_id IS NULL OR player_wallet_id = account_update_status_sel.player_wallet_id);

$$ LANGUAGE SQL;