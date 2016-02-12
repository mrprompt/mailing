-- --------------------------------------------------------------------------------
-- Routine DDL
-- --------------------------------------------------------------------------------
DELIMITER $$

DROP PROCEDURE IF EXISTS `sp_fila_insert` $$

CREATE PROCEDURE `sp_fila_insert`(
     in  sp_in_id_campanha   integer
    ,in  sp_in_id_prioridade integer
    ,in  sp_in_str_emails    text
    ,out sp_out_int_status   tinyint
    ,out sp_out_str_status   varchar(50)
)
begin
#-------documentacao----------------------------------------------------#
/*
autor: Thiago Paes
entradas:
    sp_in_id_campanha

    sp_in_id_prioridade

    sp_in_str_emails
        E-mails, no formato "nome:email" separados por pipe
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
        length(sp_in_str_emails) != 0
    &&  sp_in_id_campanha > 0
    &&  sp_in_id_prioridade > 0
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
        set @retorno = '';
        set @data    = now();

        while @i <= @limite do
            set @id_email = fn_get_elemento_por_indice(sp_in_str_emails, '|', @i);

            insert ignore into fila values(
                 null
                ,sp_in_id_campanha
                ,@id_email
                ,1
                ,sp_in_id_prioridade
                ,concat(sp_in_id_campanha, '_', @id_email)
                ,@data
            );

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