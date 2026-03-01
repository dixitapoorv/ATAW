/*


*/

--select * from util.routines(name:='public.player_logins_sel');
CALL util.function_drop(name:='public.player_logins_sel',exceptions:=ARRAY[
  'player_login_id bigint, player_wallet_id int,begin_dto timestamptz,end_dto timestamptz , OUT player_login_id bigint,OUT player_wallet_id int, OUT player_name varchar(512), OUT inserted_dto timestamptz']);

CREATE OR REPLACE FUNCTION public.player_logins_sel (
  player_login_id bigint DEFAULT NULL,
  player_wallet_id int DEFAULT NULL,
  begin_dto timestamptz DEFAULT NULL,
  end_dto timestamptz DEFAULT NULL)
RETURNS TABLE(
  player_login_id bigint,
  player_wallet_id int,
  player_name varchar(512),
  login_dto timestamptz
)
AS $$
  SELECT pl.player_login_id, pl.player_wallet_id, pl.player_name, pl.inserted_dto login_dto
  FROM public.player_logins pl
  WHERE (player_logins_sel.player_login_id IS NULL OR pl.player_login_id = player_logins_sel.player_login_id)
      AND (player_logins_sel.player_wallet_id IS NULL OR pl.player_wallet_id  = player_logins_sel.player_wallet_id)
      AND (player_logins_sel.begin_dto IS NULL OR pl.inserted_dto >= player_logins_sel.begin_dto)
      AND (player_logins_sel.end_dto IS NULL OR pl.inserted_dto < player_logins_sel.end_dto)

$$ LANGUAGE SQL;
