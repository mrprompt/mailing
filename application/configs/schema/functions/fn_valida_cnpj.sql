-- --------------------------------------------------------------------------------
-- Routine DDL
-- --------------------------------------------------------------------------------
DELIMITER $$

CREATE FUNCTION `fn_valida_cnpj`(
    CNPJ CHAR(20)
) RETURNS int(11)
    DETERMINISTIC
BEGIN
    DECLARE _CNPJ varchar (14);
    DECLARE _multiplicador_1 varchar(12);
    DECLARE _multiplicador_2 varchar(13);

    DECLARE _resultado int;
    DECLARE _contador int;

    DECLARE _digito_1 int;
    DECLARE _digito_2 int;

      DECLARE EXIT HANDLER FOR SQLEXCEPTION
          BEGIN
             RETURN 0;
          END;

    SET _contador = 1;
    SET _resultado = 0;
    SET _digito_1 = 0;
    SET _digito_2 = 0;
    SET _CNPJ = substring(CNPJ, 1, 12);

    SET _multiplicador_1 = '543298765432';
    SET _multiplicador_2 = '6543298765432';

      IF(CNPJ IS NULL) THEN
        RETURN NULL;
      END IF;

      IF(CHAR_LENGTH(CNPJ) != 14) THEN
        RETURN 0;
      END IF;

      WHILE(_contador <= 12) DO
       SET _resultado = _resultado
      + CAST( substring(_CNPJ, _contador, 1) AS UNSIGNED)
      * CAST( substring(_multiplicador_1, _contador, 1) AS UNSIGNED);
       SET _contador = _contador + 1;
      END WHILE;

      SET _resultado = _resultado%11;

      IF (_resultado < 2)THEN
        SET _digito_1 = 0;
      ELSE
        SET _digito_1 = 11 - _resultado;
      END IF;

      SET _CNPJ = CONCAT( _CNPJ, _digito_1);
      SET _contador = 1;
      SET _resultado = 0;

      WHILE(_contador <= 13) DO
        SET _resultado = _resultado
      + CAST(substring(_CNPJ, _contador, 1) AS UNSIGNED)
      * CAST(substring(_multiplicador_2, _contador, 1) AS UNSIGNED);
        SET _contador = _contador + 1;
      END WHILE;

      SET _resultado = (_resultado%11);

      IF(_resultado < 2)THEN
        SET _digito_2 = 0;
      ELSE
        SET _digito_2 = 11 - _resultado;
      END IF;

      SET _CNPJ = CONCAT( _CNPJ , _digito_2);

      IF(substring(CNPJ, 13, 1) <> _digito_1)
      OR (substring(CNPJ, 14, 1) <> _digito_2) THEN
        RETURN 0;
      END IF;

    RETURN 1;
END