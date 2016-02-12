-- --------------------------------------------------------------------------------
-- Routine DDL
-- --------------------------------------------------------------------------------
DELIMITER $$

DROP PROCEDURE IF EXISTS `sp_email_delete` $$

CREATE PROCEDURE `sp_email_delete`(
     in  sp_in_id_empresa   integer
    ,in  sp_in_id_email     text
	,out sp_out_int_status   tinyint
	,out sp_out_str_status   varchar(50)
)
begin
#-------documentacao----------------------------------------------------#
/*
autor: Thiago Paes
entradas:
    sp_in_id_status
        ID de status dos e-mails a serem recuperados
    sp_in_id_email
        ID dos e-mails separados por pipe
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
            0 != length(sp_in_id_email)
        &&  0 != (select count(id_empresa) from empresa where id_empresa = sp_in_id_empresa)
    ;
#-------fim validacao das entrada-----------------------------------------#

#-------procedimento------------------------------------------------------#
	if sp_entradas_validas then
        -- agora simulo um "explode", para pegar o nome e os e-mails, separados
        -- por : (dois pontos), e a lista completa, separada por pipe.
        -- Ex.: "Nome inteiro:nomeinteiro@provedor|nome dois:nome_dois@provedor
        -- Também já vou inserindo na tabela e-mails do dono da campanha.
        set @i      = 1;
        set @limite = LENGTH(sp_in_id_email)-LENGTH(REPLACE(sp_in_id_email, '|', '')) + 1;
        set @retorno = '';

        while @i <= @limite do
            set @r = fn_get_elemento_por_indice(sp_in_id_email, '|', @i);

            delete from email where id_email = @r and id_empresa = sp_in_id_empresa limit 1;

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

    select sp_out_int_status as int_status,
            sp_out_str_status as str_status
    ;
#-------fim mapeamento dos status-----------------------------------------#
END