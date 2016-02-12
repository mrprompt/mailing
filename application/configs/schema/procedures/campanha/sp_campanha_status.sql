-- --------------------------------------------------------------------------------
-- Routine DDL
-- --------------------------------------------------------------------------------
DELIMITER $$

DROP PROCEDURE IF EXISTS `sp_campanha_status` $$

CREATE PROCEDURE `sp_campanha_status`(
     in  sp_in_id_campanha      tinyint
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
    declare id integer;
    declare descricao varchar(30);
    declare int_done integer default 0;
    declare status   cursor for
        select id_status, str_status
        from fila_status;
    declare continue handler for sqlstate '02000' set int_done = 1;
#-------fim declaracoes iniciais------------------------------------------#

#-------validacao das entrada---------------------------------------------#
	set sp_entradas_validas =
        sp_in_id_campanha > 0
    ;
#-------fim validacao das entrada-----------------------------------------#

#-------procedimento------------------------------------------------------#
    if sp_entradas_validas then
        open status;

        set @saida = '';

        repeat fetch status into id, descricao;
            if not int_done then
                set @saida = concat(
                     @saida
                    ,descricao
                    ,': '
                    ,(select count(id_fila)
                      from fila
                      where id_campanha = sp_in_id_campanha
                      and id_status     = id)
                    ,'\n'
                );
            end if;
        until int_done end repeat;
        close status;

        select @saida as status;

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
#-------fim mapeamento dos status-----------------------------------------#
END