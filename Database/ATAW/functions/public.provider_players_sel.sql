/*


*/

--select * from util.routines(name:='public.provider_players_sel');
CALL util.function_drop(name:='public.provider_players_sel',exceptions:=ARRAY[
  'player_wallet_id int,provider_id smallint,OUT provider_external_player_id varchar(64), OUT global_player_id varchar(64)']);

CREATE OR REPLACE FUNCTION public.provider_players_sel (player_wallet_id int, provider_id smallint)
RETURNS TABLE(provider_external_player_id varchar, global_player_id varchar)
AS $$
  SELECT pp.provider_external_player_id, pp.global_player_id
  FROM public.provider_players pp
      WHERE pp.player_wallet_id=provider_players_sel.player_wallet_id
	        AND pp.provider_id = provider_players_sel.provider_id;
$$ LANGUAGE SQL;

/*
select * from public.provider_players_sel(1,1);

*/