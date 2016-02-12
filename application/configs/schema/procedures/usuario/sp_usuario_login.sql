-- --------------------------------------------------------------------------------
-- Routine DDL
-- --------------------------------------------------------------------------------
DELIMITER $$

DROP PROCEDURE IF EXISTS `sp_usuario_login` $$

CREATE PROCEDURE `sp_usuario_login`(
     in  sp_in_str_email        varchar(200)
    ,in  sp_in_str_senha        varchar(120)
    ,out sp_out_int_status      tinyint
    ,out sp_out_str_status      varchar(50)
)
begin
#-------documentacao----------------------------------------------------#
/*
autor: Thiago Paes
entradas:
    sp_in_str_email
    sp_in_str_senha

saidas:
	int_status
		codigo do status da Solicitação
	str_status
		descricao do status da Solicitação
descricao:
	Esta SP tem como objetivo listar os e-mails que estão na fila de envio
    de uma determinada campanha.

retorno:


*/
#-------documentacao------------------------------------------------------#
#-------declaracoes iniciais----------------------------------------------#
    declare sp_entradas_validas boolean;

#-------fim declaracoes iniciais------------------------------------------#

#-------validacao das entrada---------------------------------------------#
	set sp_entradas_validas =
            0 != fn_valida_email(sp_in_str_email)
        &&  0 != length(sp_in_str_senha)
    ;
#-------fim validacao das entrada-----------------------------------------#

#-------procedimento------------------------------------------------------#
	if sp_entradas_validas then
        # verifico se o usuaário realmente existe
        if (1 = (select count(id_usuario) from usuario
                 where str_email = sp_in_str_email
                 and str_senha = sha1(sp_in_str_senha) limit 1))
        then
            set sp_out_int_status = 0;
        else
            set sp_out_int_status = 2;
        end if;
	else
		set sp_out_int_status = 1;
	end if;
#-------fim procedimento--------------------------------------------------#

#-------mapeamento dos status---------------------------------------------#
	set sp_out_str_status =
		case sp_out_int_status
            when 0 then 'Solicitação efetuada com sucesso.'
            when 1 then 'Entradas inválidas.'
            when 2 then 'E-mail/senha inválidos.'
            else 'Status nao inicializado ou nao mapeado.'
		end;

    select sp_out_int_status as int_status,
           sp_out_str_status as str_status
    ;

    if (sp_out_int_status = 0) then
        select u.*
        from   usuario u
        where  u.str_email = sp_in_str_email;

        select e.*
        from   empresa e
        join   usuario u on e.id_empresa = u.id_empresa
        where  u.str_email = sp_in_str_email
        limit 1;
    end if;
#-------fim mapeamento dos status-----------------------------------------#
END