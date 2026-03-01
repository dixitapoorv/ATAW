/*************************************************************************
DATE          VERSION              NAME                    REFERENCE
2022-03-23    Wallet2.0            Shabina                 WI#578392/583130
Added validation for lenght of string value

2022-04-25    Wallet2.0            Shabina                 WI#592011/593650
Changes case of json data to map with API
*************************************************************************/
--select * from util.routines(name:='public.is_valid');
CALL util.function_drop(name:='public.is_valid', exceptions:=ARRAY['value text,validation json,returns boolean']);

CREATE OR REPLACE FUNCTION public.is_valid
(
  value text,
  validation json
)
RETURNS boolean
AS $$
DECLARE _is_valid boolean;
BEGIN 

  _is_valid := public.is_data_type(value, (validation->>'DataType')::varchar(32));
  

  _is_valid := _is_valid AND CASE
    WHEN trim(value) = '' AND not coalesce((validation->>'AllowEmpty')::boolean,false) THEN false
    WHEN value is null AND not coalesce((validation->>'AllowNull')::boolean,false) THEN false
    WHEN(validation->>'DataType')::varchar(32) like 'array%' 
      and coalesce((validation->>'maxLength')::int,0) != 0
      and array_length(string_to_array(value,','),1) > coalesce((validation->>'maxLength')::int,array_length(string_to_array(value,','),1))
      THEN false
    WHEN(validation->>'DataType')::varchar(32) like 'array%' 
      and coalesce((validation->>'minLength')::int,0) != 0
      and array_length(string_to_array(value,','),1) < coalesce((validation->>'minLength')::int,array_length(string_to_array(value,','),1))
      THEN false
    WHEN(validation->>'DataType')::varchar(32) not like 'array%'
      and coalesce((validation->>'length')::int,0) != 0
      and  length(trim(value)) > coalesce((validation->>'length')::int,0)
      THEN false
    ELSE true
  end;

  RETURN _is_valid;
END;
$$ LANGUAGE plpgsql;


/*
SELECT public.is_valid(
    '1,2,1,2', 
    '{ "DataType":"array<int>", "AllowNull":false, "AllowEmpty":false, "minLength":"1", "maxLength":"2"}'
);

SELECT public.is_valid(
    '1,2,1,2', 
    '{ "DataType":"array<int>", "AllowNull":false, "AllowEmpty":false, "minLength":"1", "maxLength":"2"}'
);

SELECT public.is_valid(
	'testingLenght', 
	'{ "DataType":"varchar", "AllowNull":false, "AllowEmpty":false, "length":"10"}'
);

*/