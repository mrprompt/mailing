-- --------------------------------------------------------------------------------
-- Routine DDL
-- --------------------------------------------------------------------------------
DELIMITER $$

DROP PROCEDURE IF EXISTS `sp_email_grupo_update` $$

CREATE PROCEDURE `sp_email_grupo_update`(
     in  sp_in_id_grupo tinyint
    ,in  sp_in_str_emails varchar(2500)
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
#-------fim declaracoes iniciais------------------------------------------#

#-------validacao das entrada---------------------------------------------#
    set sp_entradas_validas =
            true
    ;
#-------fim validacao das entrada-----------------------------------------#

#-------procedimento------------------------------------------------------#
    if sp_entradas_validas then
        -- agora simulo um "explode", para pegar o nome e os e-mails, separados
        -- por : (dois pontos), e a lista completa, separada por pipe.
        -- Ex.: "Nome inteiro:nomeinteiro@provedor|nome dois:nome_dois@provedor
        -- Também já vou inserindo na tabela e-mails do dono da campanha.
        set @i       = 1;
        set @limite  = LENGTH(sp_in_str_emails)-LENGTH(REPLACE(sp_in_str_emails, '|', '')) + 1;

        while @i <= @limite do
            set @r = fn_get_elemento_por_indice(sp_in_str_emails, '|', @i);

            update email
            set id_email_grupo = sp_in_id_grupo
            where id_email = @r
            limit 1;

            set @i = @i + 1;
        end while;
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