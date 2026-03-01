/*


*/

--select * from util.routines(name:='system.settings_sel');
CALL util.function_drop(name:='system.settings_sel',exceptions:=ARRAY[
  'id int, key varchar(128),type varchar(64),OUT key varchar,OUT value text,OUT meta json']);

CREATE OR REPLACE FUNCTION system.settings_sel (key varchar(128) DEFAULT NULL, type varchar(64) DEFAULT NULL)
RETURNS TABLE(id int, key varchar(128), value text, meta json)
AS $$
  SELECT s.setting_id id,s.key, s.value, s.meta
  FROM system.settings s
  WHERE (settings_sel.key IS NULL OR s.key like settings_sel.key)
    AND (settings_sel.type IS NULL OR lower(s.meta->>'SettingType')=lower(settings_sel.type));
$$ LANGUAGE SQL;

/*
select * from system.settings_sel(null, null, null);
select * from system.settings_sel(null, null, 'Service');
select * from system.settings
*/