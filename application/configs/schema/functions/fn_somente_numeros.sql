-- --------------------------------------------------------------------------------
-- Routine DDL
-- --------------------------------------------------------------------------------
DELIMITER $$

CREATE FUNCTION `fn_somente_numeros`(
	 val VARCHAR( 255 )
) RETURNS varchar(255) CHARSET utf8
    DETERMINISTIC
BEGIN
    DECLARE idx INT DEFAULT 0;
    IF ISNULL(val) THEN RETURN NULL; END IF;
    IF LENGTH(val) = 0 THEN RETURN ""; END IF;

    SET idx = REPLACE(val,".","");
    SET idx = LENGTH(val);

    WHILE idx > 0 DO
        IF fn_is_number(SUBSTRING(val,idx,1)) = 0 THEN
            SET val = REPLACE(val,SUBSTRING(val,idx,1),"");
            SET idx = LENGTH(val)+1;
        END IF;

        SET idx = idx - 1;
    END WHILE;

    RETURN val;
END