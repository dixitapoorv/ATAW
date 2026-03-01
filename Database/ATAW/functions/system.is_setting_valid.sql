/*************************************************************************
DATE          VERSION              NAME                    REFERENCE
2022-03-23    Wallet2.0            Shabina                 WI#584872/584908
Initial Version

2022-05-11    Wallet2.0           Shabina                 WI#591529/591522
Fixed execution error
*************************************************************************/
--select * from util.routines(name:='system.is_setting_valid');
CALL util.function_drop(name:='system.is_setting_valid', exceptions:=ARRAY['value text,validation json,returns boolean']);

CREATE OR REPLACE FUNCTION system.is_setting_valid(
    value text,
    validation json)
RETURNS boolean
AS $$
BEGIN
  RETURN public.is_valid(value,validation);
END;
$$ LANGUAGE plpgsql;
