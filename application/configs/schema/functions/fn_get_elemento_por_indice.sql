-- --------------------------------------------------------------------------------
-- Routine DDL
-- --------------------------------------------------------------------------------
DELIMITER $$

CREATE FUNCTION `fn_get_elemento_por_indice`(
	 fn_in_txt_lista     LONGTEXT
	,fn_in_str_separador VARCHAR( 50)
	,fn_in_int_indice    BIGINT
) RETURNS longtext CHARSET latin1
    DETERMINISTIC
BEGIN
	IF
		fn_conta_caracteres( fn_in_str_separador, fn_in_txt_lista ) + 1 < fn_in_int_indice
		OR
		fn_in_int_indice < 1
	THEN
		RETURN NULL;
	ELSE
		RETURN SUBSTRING_INDEX( SUBSTRING_INDEX( fn_in_txt_lista, fn_in_str_separador, fn_in_int_indice ), fn_in_str_separador, -1 );
	END IF;
END