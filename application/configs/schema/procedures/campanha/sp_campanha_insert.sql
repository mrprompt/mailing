-- --------------------------------------------------------------------------------
-- Routine DDL
-- --------------------------------------------------------------------------------
DELIMITER $$

DROP PROCEDURE IF EXISTS `sp_campanha_insert` $$

CREATE PROCEDURE `sp_campanha_insert`(
     in  sp_in_id_empresa       integer(11)
    ,in  sp_in_id_template      integer(11)
    ,in  sp_in_id_prioridade    integer(11)
    ,in  sp_in_str_titulo       varchar(255)
    ,in  sp_in_dat_inicio       datetime
    ,in  sp_in_dat_fim          datetime
    ,out sp_out_int_status      tinyint(2)
    ,out sp_out_str_status      varchar(50)
)
BEGIN
#-------documentacao----------------------------------------------------#
/*
autor: Thiago Paes
entradas:
    sp_in_id_empresa
        ID de cadastro da empresa
    sp_in_id_template
        ID do template
    sp_in_str_titulo
        Título da campanha. É o título do e-mail, aceitando as variáveis
        de template para substituição automática.
    sp_in_dat_inicio
    sp_in_dat_fim

saidas:
	int_status
		codigo do status da Solicitação
	str_status
		descricao do status da Solicitação
descricao:
	Esta SP tem como objetivo criar uma campanha para envio e salvar os e-mails
    na base do cliente.

retorno:

*/
#-------documentacao------------------------------------------------------#
#-------declaracoes iniciais----------------------------------------------#
    declare sp_entradas_validas boolean;
#-------fim declaracoes iniciais------------------------------------------#

#-------validacao das entrada---------------------------------------------#
    set sp_entradas_validas =
        sp_in_id_empresa > 0
    &&  sp_in_id_template > 0
    &&  sp_in_id_prioridade > 0
    &&  length(sp_in_str_titulo) > 0
    &&  length(sp_in_dat_inicio) > 0
    &&  length(sp_in_dat_fim) > 0
;
#-------fim validacao das entrada-----------------------------------------#

#-------procedimento------------------------------------------------------#
    if sp_entradas_validas then
        insert into campanha values (
             null
            ,sp_in_id_empresa
            ,sp_in_id_template
            ,sp_in_id_prioridade
            ,convert(sp_in_str_titulo  USING utf8)
            ,now()
            ,now()
            ,sp_in_dat_inicio
            ,sp_in_dat_fim
            ,'1'
        );

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
           sp_out_str_status as str_status,
           last_insert_id() as id_campanha
    ;
#-------fim mapeamento dos status-----------------------------------------#
END