-- --------------------------------------------------------------------------------
-- Routine DDL
-- --------------------------------------------------------------------------------
DELIMITER $$

CREATE FUNCTION `fn_valida_cpf`(
	SP_STR_CPF varchar(300)
) RETURNS tinyint(1)
    DETERMINISTIC
begin
	declare valido int(2) default 0;
	declare soma int(10) default 0;
	declare indice int(10) default 0;
	declare dig1 int(10) default 0;
	declare dig2 int(10) default 0;

	if length(SP_STR_CPF) = 11 && SP_STR_CPF not in (00000000000, 11111111111, 22222222222, 33333333333,
			44444444444, 55555555555, 66666666666, 77777777777, 88888888888, 99999999999) then

			#-- Calculo do 1 di­gito
			set soma = 0;
			set indice = 1;
			while (indice <= 9) do
	 			set soma = soma + cast(substring(SP_STR_CPF,indice,1) as unsigned) * (11 - indice);
	 			set indice = indice + 1;
	 		END while;
	 		set dig1 = 11 - (soma % 11);
	 		if (dig1 > 9) THEN
				set dig1 = 0;
			end if;

			#-- Calculo do 2 di­gito
			set soma = 0;
			set indice = 1;
			while (indice <= 10) DO
				set soma = soma + cast(substring(SP_STR_CPF,indice,1) AS UNSIGNED) * (12 - indice);
				set indice = indice + 1;
	 		end while;
			set dig2 = 11 - (soma % 11);
	 		if dig2 > 9 THEN
				set dig2 = 0;
			end if;

			#-- Validando
			if (dig1 = substring(SP_STR_CPF,length(SP_STR_CPF)-1,1)) AND (dig2 = substring(SP_STR_CPF,length(SP_STR_CPF),1)) then
				set valido = 1;
				return 1;
			end if;
	end if;
	return 0;
end