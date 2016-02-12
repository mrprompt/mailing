-- --------------------------------------------------------------------------------
-- Routine DDL
-- --------------------------------------------------------------------------------
DELIMITER $$

DROP PROCEDURE IF EXISTS `sp_empresa_update` $$

CREATE PROCEDURE `sp_empresa_update`(
     in  sp_in_id_empresa       integer(11)
    ,in  sp_in_str_nome         varchar(255)
    ,in  sp_in_str_email        varchar(200)
    ,in  sp_in_int_telefone     varchar(20)
    ,in  sp_in_int_cep          varchar(10)
    ,out sp_out_int_status      tinyint(2)
    ,out sp_out_str_status      varchar(50)
)
begin
#-------documentacao----------------------------------------------------#
/*
autor: Thiago Paes
entradas:
    sp_in_id_empresa
    sp_in_str_nome
    sp_in_str_email
    sp_in_int_telefone
    sp_in_int_cep

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
#-------fim declaracoes iniciais------------------------------------------#

#-------validacao das entrada---------------------------------------------#
	set sp_entradas_validas =
            0 != sp_in_id_empresa
        &&  0 != length(sp_in_str_nome)
        &&  0 != fn_valida_email(sp_in_str_email)
        && 10 = length(fn_somente_numeros(sp_in_int_telefone))
        &&  8 = length(fn_somente_numeros(sp_in_int_cep))
    ;
#-------fim validacao das entrada-----------------------------------------#

#-------procedimento------------------------------------------------------#
	if sp_entradas_validas then
            set @query    = concat(
                'update empresa set '
                ,' str_nome = \'', sp_in_str_nome, '\''
                ,',str_email = \'', sp_in_str_email, '\''
                ,',int_telefone = \'', fn_somente_numeros(sp_in_int_telefone), '\''
                ,',int_cep = \'', fn_somente_numeros(sp_in_int_cep), '\''
                ,' where id_empresa = ', sp_in_id_empresa , ' limit 1;'
            );
            prepare query from @query;
            execute query;

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
            when 3 then 'CNPJ em uso por outra empresa.'
            else 'Status nao inicializado ou nao mapeado.'
		end;

    select sp_out_int_status as int_status,
            sp_out_str_status as str_status
    ;
#-------fim mapeamento dos status-----------------------------------------#
END