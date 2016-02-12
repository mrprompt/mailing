-- --------------------------------------------------------------------------------
-- Routine DDL
-- --------------------------------------------------------------------------------
DELIMITER $$

CREATE FUNCTION `fn_valida_email`(
    p_email varchar(64)
) RETURNS tinyint(1)
    DETERMINISTIC
BEGIN
    CASE WHEN NOT (SELECT p_email REGEXP '^[A-Z0-9._%-]+@[A-Z0-9.-]+\.[A-Z]{2,4}$')
    THEN
        -- bad data
        RETURN 0;
    ELSE
        -- good email
        RETURN 1;
    END CASE;
END