-- --------------------------------------------------------------------------------
-- Routine DDL
-- --------------------------------------------------------------------------------
DELIMITER $$

DROP FUNCTION IF EXISTS `fn_remove_acentos` $$

CREATE FUNCTION `fn_remove_acentos`(
    Texto varchar(150)
) RETURNS varchar(150) CHARSET latin1
begin
    declare Acentos, SemAcentos, Resultado varchar(150);
    declare Cont int;

    set Acentos     = 'áàãâéêíóôõúüñçÁÀÃÂÉÊÍÓÔÕÚÜÑÇ';
    set SemAcentos  = 'aaaaeeiooouuncAAAAEEIOOOUUNC-';
    set Cont        = char_length(Texto);
    set Resultado   = upper(Texto);

    while Cont > 0 do
        set Resultado = replace(Resultado, substring(Acentos, Cont, 1), substring(SemAcentos, Cont, 1));
        set Cont = Cont - 1;
    end while;

    return lower(Resultado);
end