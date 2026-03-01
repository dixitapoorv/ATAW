/*************************************************************************
DATE          VERSION              NAME                    REFERENCE
2023-02-20    Dev/15.3.0/MOP      Shabina                  WI#717885
Initial Version
*************************************************************************/

--select * from util.routines(name:='public.sessions_sel');
CALL util.function_drop(name:='public.sessions_sel',exceptions:=ARRAY[
  'session_guid uuid, player_wallet_id in,OUT session_guid uuid,OUT player_wallet_id int,OUT expired_dto timestamptz, OUT external_player_id varchar(64),OUT partial_active boolean']);

CREATE OR REPLACE FUNCTION public.sessions_sel (session_guid uuid, player_wallet_id int)
RETURNS TABLE(session_guid uuid, player_wallet_id int, expired_dto timestamptz,external_player_id varchar(64), partial_active boolean, allowed_expired_session int)
AS $$
  SELECT s.session_guid, s.player_wallet_id, s.expired_dto, s.external_player_id, s.partial_active, s.allowed_expired_session
  FROM public.sessions s
  WHERE s.player_wallet_id = sessions_sel.player_wallet_id
  AND s.session_guid  = sessions_sel.session_guid;
$$ LANGUAGE SQL;
