-- --------------------------------------------------------------------------------
-- Routine DDL
-- --------------------------------------------------------------------------------
DELIMITER $$

DROP PROCEDURE IF EXISTS `sp_modelo` $$

CREATE PROCEDURE `sp_modelo`(
     out sp_out_int_status      tinyint(2)
    ,out sp_out_str_status      varchar(50)
)
begin
#-------documentacao----------------------------------------------------#
/*
autor:
criado em:
modificado em:
entradas:

saidas:

descricao:

retorno:


*/
#-------documentacao------------------------------------------------------#
#-------declaracoes iniciais----------------------------------------------#
    declare sp_entradas_validas boolean;
#-------fim declaracoes iniciais------------------------------------------#

#-------validacao das entrada---------------------------------------------#

    set sp_entradas_validas =
        true
    ;
#-------fim validacao das entrada-----------------------------------------#

#-------procedimento------------------------------------------------------#
    if sp_entradas_validas then
        set sp_out_int_status = 0;
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
            when 2 then 'E-mail já cadastrado.'
            else 'Status nao inicializado ou nao mapeado.'
        end;

    select sp_out_int_status as int_status,
            sp_out_str_status as str_status
    ;
#-------fim mapeamento dos status-----------------------------------------#
END