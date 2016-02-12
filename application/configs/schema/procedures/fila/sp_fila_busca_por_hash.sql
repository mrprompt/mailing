-- --------------------------------------------------------------------------------
-- Routine DDL
-- --------------------------------------------------------------------------------
DELIMITER $$

DROP PROCEDURE IF EXISTS `sp_fila_busca_por_hash` $$

CREATE PROCEDURE `sp_fila_busca_por_hash`(
     in  sp_in_str_hash        varchar(255)
	,out sp_out_int_status      tinyint
	,out sp_out_str_status      varchar(50)
)
begin
#-------documentacao----------------------------------------------------#
/*
autor: Thiago Paes
entradas:
    sp_in_str_hash
        Hash da fila
saidas:
	int_status
		codigo do status da Solicitação
	str_status
		descricao do status da Solicitação
descricao:
	Esta SP tem como objetivo recuperar um e-mail por seu hash.

retorno:


*/
#-------documentacao------------------------------------------------------#
#-------declaracoes iniciais----------------------------------------------#
    declare sp_entradas_validas boolean;

#-------fim declaracoes iniciais------------------------------------------#

#-------validacao das entrada---------------------------------------------#
	set sp_entradas_validas =
            length(sp_in_str_hash) > 0
    ;
#-------fim validacao das entrada-----------------------------------------#

#-------procedimento------------------------------------------------------#
	if sp_entradas_validas then
                    set @query = concat(
                        'select distinct sql_calc_found_rows '
                        ,  'e.id_empresa, e.str_nome as str_empresa, '
                        ,  'e.int_telefone, e.int_cnpj, e.int_cep, e.str_email as str_empresa_email, '
                        ,  'e.str_logradouro, e.int_numero, e.str_complemento, '
                        ,  'c.*, '
                        ,  'f.*, '
                        ,  's.* '
                        ,'from empresa e '
                        ,'join campanha c on c.id_empresa = e.id_empresa '
                        ,'join fila f on f.id_campanha = c.id_campanha '
                        ,'join status s on f.int_status = s.id_status '
                        ,'where f.str_hash = \'', sp_in_str_hash, '\' '
                        #,'and f.id_campanha = c.id_campanha '
                        #,'and c.id_empresa = '
                        ,'limit 1'
                    );
                    prepare query from @query;
                    execute query;

                    set @vazio = false;

                    select found_rows() as total;

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

    /*select sp_out_int_status as int_status,
           sp_out_str_status as str_status
    ;*/
#-------fim mapeamento dos status-----------------------------------------#
END