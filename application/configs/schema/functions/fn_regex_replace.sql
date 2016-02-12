-- --------------------------------------------------------------------------------
-- Routine DDL
-- --------------------------------------------------------------------------------
DELIMITER $$

CREATE FUNCTION `fn_regex_replace`(
    pattern varchar(1000),
    replacement varchar(1000),
    original varchar(1000)
) RETURNS varchar(1000) CHARSET latin1 DETERMINISTIC
begin
 declare temp varchar(1000);
 declare ch varchar(1);
 declare i int;
 set i = 1;
 set temp = '';
 if original regexp pattern then
  loop_label: loop
   if i>char_length(original) then
    leave loop_label;
   end if;
   set ch = substring(original,i,1);
   if not ch regexp pattern then
    set temp = concat(temp,ch);
   else
    set temp = concat(temp,replacement);
   end if;
   set i=i+1;
  end loop;
 else
  set temp = original;
 end if;
 return temp;
end