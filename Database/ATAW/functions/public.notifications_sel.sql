/*************************************************************************
DATE          VERSION              NAME                    REFERENCE
2022-07-01    Wallet2.0            Shabina                 WI#597991/598630
Renamed column from notification_context to notification_content
*************************************************************************/

CALL util.function_drop(name:='public.notifications_sel',exceptions:=ARRAY[
  'notification_id int, player_wallet_id int,notification_type smallint,external_reference_id varchar(256), OUT notification_context text, OUT delivered_dto timestamptz, OUT inserted_dto timestamptz, OUT updated_dto timestamptz,status varchar(64)']);

CREATE OR REPLACE FUNCTION public.notifications_sel (
  notification_id int DEFAULT NULL,
  player_wallet_id int DEFAULT NULL,
  notification_type smallint DEFAULT NULL,
  external_reference_id varchar(256) DEFAULT NULL,
  status varchar(64) DEFAULT NULL)
RETURNS TABLE(
  notification_id int,
  player_wallet_id int,
  notification_type smallint,
  external_reference_id varchar,
  notification_content text,
  delivered_dto timestamptz,
  inserted_dto timestamptz,
  updated_dto timestamptz,
  status varchar)
AS $$
  SELECT n.notification_id, n.player_wallet_id, n.notification_type, n.external_reference_id, n.notification_content, n.delivered_dto, n.inserted_dto, n.updated_dto, n.status
  FROM public.notifications n
  WHERE (notifications_sel.notification_id IS NULL OR n.notification_id= notifications_sel.notification_id)
    AND (notifications_sel.player_wallet_id IS NULL OR n.player_wallet_id= notifications_sel.player_wallet_id)
    AND (notifications_sel.notification_type IS NULL OR n.notification_type= notifications_sel.notification_type)
    AND (notifications_sel.external_reference_id IS NULL OR n.external_reference_id= notifications_sel.external_reference_id)
    AND (notifications_sel.status IS NULL OR n.status= notifications_sel.status);
$$ LANGUAGE SQL;
