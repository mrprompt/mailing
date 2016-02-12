-- --------------------------------------------------------------------------------
-- Routine DDL
-- --------------------------------------------------------------------------------
DELIMITER $$

DROP PROCEDURE IF EXISTS `sp_fila_update` $$

CREATE PROCEDURE `sp_fila_update`(
     in  sp_in_id_campanha tinyint
    ,in  sp_in_str_id_fila varchar(2500)
    ,in  sp_in_int_status  tinyint
    ,out sp_out_int_status tinyint
    ,out sp_out_str_status varchar(50)
)
begin
#-------documentacao----------------------------------------------------#
/*
autor: Thiago Paes
entradas:
    sp_in_id_campanha
        ID da campanha na fila
    sp_in_str_id_fila
        ID do e-mail na fila, separados por pipe
    sp_in_int_status
        Status a ser atribuído - vide tabela status.

saidas:
	int_status
		codigo do status da Solicitação
	str_status
		descricao do status da Solicitação
descricao:
	Esta SP tem como objetivo atualizar o status de uma mensagem na fila.

retorno:


*/
#-------documentacao------------------------------------------------------#
#-------declaracoes iniciais----------------------------------------------#
    declare sp_entradas_validas boolean;
    declare id                  int;
    declare titulo              varchar(255);
    declare email               varchar(255);
    declare corpo               text;
#-------fim declaracoes iniciais------------------------------------------#

#-------validacao das entrada---------------------------------------------#
	set sp_entradas_validas =
            (0 != (select count(id_campanha) from campanha where id_campanha = sp_in_id_campanha))
;
#-------fim validacao das entrada-----------------------------------------#

#-------procedimento------------------------------------------------------#
    if sp_entradas_validas then
        update fila f
        inner join fila_tmp t on f.id_fila = t.id_fila
        set f.id_status = sp_in_id_status_novo
        where f.id_status = sp_in_id_status;

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