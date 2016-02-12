-- --------------------------------------------------------------------------------
-- Routine DDL
-- --------------------------------------------------------------------------------
DELIMITER $$

DROP PROCEDURE IF EXISTS `sp_campanha_vincula_grupo` $$

CREATE PROCEDURE `sp_campanha_vincula_grupo`(
     in  sp_in_id_campanha   integer
    ,in  sp_in_str_grupo     varchar(2048)
    ,out sp_out_int_status   tinyint
    ,out sp_out_str_status   varchar(50)
)
begin
#-------documentacao----------------------------------------------------#
/*
autor: Thiago Paes
entradas:
    sp_in_id_campanha
        ID da campanha a ser vinculado os grupos
    sp_in_str_grupo
        Lista de ID dos grupos a serem vinculados a campanha, separados 
        por pipe.

saidas:
    int_status
            codigo do status da Solicitação
    str_status
            descricao do status da Solicitação

descricao:
    Insere os e-mails dos grupos citados a fila e envio de uma campanha.

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
        set @i      = 1;
        set @limite = LENGTH(sp_in_str_grupo)-LENGTH(REPLACE(sp_in_str_grupo, '|', '')) + 1;

        while @i <= @limite do
            set @r = fn_get_elemento_por_indice(sp_in_str_grupo, '|', @i);

            insert ignore into fila 
                (id_fila, id_campanha, id_email, id_status, id_prioridade, str_hash, dat_log) 
            select 
                null, sp_in_id_campanha, e.id_email, 1, 1, 
                concat(sp_in_id_campanha, '_', e.id_email),
                now()
            from 
                email e 
            where 
                e.id_email_grupo = @r 
            and e.int_status = 1;

            set @i = @i + row_count();
        end while;
        set sp_out_int_status = 0;
    end if;
#-------fim procedimento--------------------------------------------------#

#-------mapeamento dos status---------------------------------------------#
    set sp_out_str_status =
        case sp_out_int_status
            when 0 then 'Solicitação efetuada com sucesso.'
            when 1 then 'Entradas inválidas.'
            else 'Status nao inicializado ou nao mapeado.'
        end;

    select  @i as int_vinculados, 
            sp_out_int_status as int_status,
            sp_out_str_status as str_status
    ;
#-------fim mapeamento dos status-----------------------------------------#
END