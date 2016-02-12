-- --------------------------------------------------------------------------------
-- Routine DDL
-- --------------------------------------------------------------------------------
DELIMITER $$

DROP PROCEDURE IF EXISTS `sp_campanha_delete` $$

CREATE PROCEDURE `sp_campanha_delete`(
     in  sp_in_id_campanha      tinyint
    ,in  sp_in_id_empresa       tinyint
    ,out sp_out_int_status      tinyint
    ,out sp_out_str_status      varchar(50)
)
begin
#-------documentacao----------------------------------------------------#
/*
autor: Thiago Paes
entradas:
    sp_in_id_campanha
        ID de cadastro da campanha
    sp_in_id_empresa
        ID da empresa responsável pela campanha
saidas:
	int_status
		codigo do status da Solicitação
	str_status
		descricao do status da Solicitação
descricao:
	Esta SP tem como objetivo remover uma campanha.
retorno:

*/
#-------documentacao------------------------------------------------------#
#-------declaracoes iniciais----------------------------------------------#
    declare sp_entradas_validas boolean;
#-------fim declaracoes iniciais------------------------------------------#

#-------validacao das entrada---------------------------------------------#
	set sp_entradas_validas =
            (0 != (
                select count(e.id_empresa)
                from empresa e
                join campanha c on c.id_empresa = e.id_empresa
                where e.id_empresa = sp_in_id_empresa
                and   c.id_campanha = sp_in_id_campanha
                )
            )
    ;
#-------fim validacao das entrada-----------------------------------------#

#-------procedimento------------------------------------------------------#
	if sp_entradas_validas then
        -- insiro a campanha na tabela e salvo o id atribuído
        update campanha set int_status = '0'
        where id_campanha = sp_in_id_campanha
        and id_empresa = sp_in_id_empresa
        limit 1;

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