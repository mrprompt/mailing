-- --------------------------------------------------------------------------------
-- Routine DDL
-- --------------------------------------------------------------------------------
DELIMITER $$

DROP PROCEDURE IF EXISTS `sp_email_select_por_empresa` $$

CREATE PROCEDURE `sp_email_select_por_empresa`(
     in  sp_in_id_empresa   integer
	,out sp_out_int_status   tinyint
	,out sp_out_str_status   varchar(50)
)
begin
#-------documentacao----------------------------------------------------#
/*
autor: Thiago Paes
entradas:
    sp_in_id_empresa
        ID da empresa
saidas:
	int_status
		codigo do status da Solicitação
	str_status
		descricao do status da Solicitação
descricao:
	Quebra uma lista de e-mails e insere no banco
retorno:

*/
#-------documentacao------------------------------------------------------#
#-------declaracoes iniciais----------------------------------------------#
    declare sp_entradas_validas boolean;
    declare id                  integer;
    declare int_done            integer default 0;
    declare cur_emails          cursor for
        select id_email
        from email
        where   1
        and     id_empresa  = sp_in_id_empresa;
	declare continue handler for sqlstate '02000' set int_done = 1;
#-------fim declaracoes iniciais------------------------------------------#

#-------validacao das entrada---------------------------------------------#
	set sp_entradas_validas =
            0 != (select count(id_empresa) from empresa where id_empresa = sp_in_id_empresa)
    ;
#-------fim validacao das entrada-----------------------------------------#

#-------procedimento------------------------------------------------------#
	if sp_entradas_validas then
        open cur_emails;

        repeat fetch cur_emails into id;
            if not int_done then
                set @retorno = concat(@retorno, '|', id);
            end if;
        until int_done end repeat;

        close cur_emails;

        select substring(@retorno, 2) as ids_emails;

        set sp_out_int_status = 0;
	else
		set sp_out_int_status = 1;
	end if;
#-------fim procedimento--------------------------------------------------#

#-------mapeamento dos status---------------------------------------------#
	set sp_out_str_status =
		case sp_out_int_status
			when 0 then 'Solicitação efetuada com sucesso.'
			when 1 then 'Entradas inválidas.'
			else 'Status nao inicializado ou nao mapeado.'
		end;

    select sp_out_int_status as int_status,
            sp_out_str_status as str_status
    ;
#-------fim mapeamento dos status-----------------------------------------#
END