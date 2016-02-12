-- --------------------------------------------------------------------------------
-- Routine DDL
-- --------------------------------------------------------------------------------
DELIMITER $$

CREATE FUNCTION `fn_mascara_filtro_para_where`(
	 sp_in_str_mascara  VARCHAR(2500)
	,sp_in_str_filtro   VARCHAR(2500)
	,sp_in_str_operador VARCHAR(  5)
) RETURNS longtext CHARSET latin1
    DETERMINISTIC
BEGIN
	DECLARE sp_int_indice BIGINT DEFAULT 1;
	DECLARE sp_str_item_mascara VARCHAR(500);
	DECLARE sp_str_item_filtro  VARCHAR(500);
	DECLARE sp_str_where VARCHAR(2500) DEFAULT '';

	IF sp_in_str_mascara = '' OR sp_in_str_filtro = ''
	THEN
		RETURN '';
	ELSE
		WHILE fn_get_elemento_por_indice( sp_in_str_mascara, '|', sp_int_indice ) IS NOT NULL
		DO
			SET sp_str_item_mascara = fn_get_elemento_por_indice( sp_in_str_mascara, '|', sp_int_indice );
			SET sp_str_item_filtro  = fn_get_elemento_por_indice( sp_in_str_filtro , '|', sp_int_indice );
			CASE
				WHEN sp_str_item_filtro REGEXP '\,'
				THEN
					SET sp_str_item_filtro = REPLACE( CONCAT(' between ',sp_str_item_filtro),',',' and ');
					SET sp_str_item_filtro = CASE WHEN sp_str_item_filtro REGEXP '.*(19[0-9]{2}|2[0-9]{3})-(0[1-9]|1[012])-([123]0|[012][1-9]|31).*'
						THEN
							CONCAT(REPLACE(REPLACE(sp_str_item_filtro,' and ','" and "'),' between ',' between "'),'"')
						ELSE
							sp_str_item_filtro
					END;
				WHEN sp_str_item_mascara LIKE 'int%'
				THEN
					SET sp_str_item_filtro = CONCAT(' like "%',sp_str_item_filtro,'%"');
				WHEN sp_str_item_mascara LIKE 'id%' OR sp_str_item_mascara LIKE 'flo%'
				THEN
					SET sp_str_item_filtro = CONCAT(' = ',sp_str_item_filtro);
				WHEN sp_str_item_filtro REGEXP '^:.+&.+$'
				THEN
					SET sp_str_item_filtro = REPLACE( sp_str_item_filtro, ':', ' between "' );
					SET sp_str_item_filtro = REPLACE( sp_str_item_filtro, '&', '" and "' );
					SET sp_str_item_filtro = CONCAT( sp_str_item_filtro, '"' );
				WHEN sp_str_item_filtro REGEXP '^[^,]+(,[^,]+)*$'
				THEN
					SET sp_str_item_filtro = CONCAT( ' like "%', sp_str_item_filtro, '%"' );
					SET sp_str_item_filtro = REPLACE( sp_str_item_filtro, ',', '","' );
				ELSE
					SET sp_str_item_filtro = 'erro';
			END CASE;
			SET sp_str_where = CONCAT(
				 sp_str_where
				,' ', CASE sp_str_where WHEN '' THEN '' ELSE sp_in_str_operador END, ' '
				,sp_str_item_mascara
				,sp_str_item_filtro
			);
			SET sp_int_indice = sp_int_indice + 1;
		END WHILE;
		SET sp_str_where = CASE sp_str_where WHEN '' THEN '' ELSE CONCAT( ' (', sp_str_where, ')' ) END;
		RETURN IFNULL(sp_str_where,'');
	END IF;
END