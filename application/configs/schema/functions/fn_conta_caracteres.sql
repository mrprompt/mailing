-- --------------------------------------------------------------------------------
-- Routine DDL
-- --------------------------------------------------------------------------------
DELIMITER $$

CREATE FUNCTION `fn_conta_caracteres`(
	 CARACTER VARCHAR( 255 )
	,STRING TEXT
) RETURNS bigint(20)
    DETERMINISTIC
BEGIN
	RETURN ( LENGTH( STRING ) - LENGTH( REPLACE( STRING, CARACTER, '') ) ) / LENGTH( CARACTER );
END