-- --------------------------------------------------------------------------------
-- Routine DDL
-- --------------------------------------------------------------------------------
DELIMITER $$

DROP PROCEDURE IF EXISTS `sp_email_insert` $$

CREATE PROCEDURE `sp_email_insert`(
     in  sp_in_id_empresa   integer
    ,in  sp_in_id_grupo     integer
    ,in  sp_in_str_emails   text
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
    sp_in_id_grupo

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
            0 != length(sp_in_str_emails)
        &&  sp_in_id_grupo > 0
        &&  0 != (select count(id_empresa) from empresa where id_empresa = sp_in_id_empresa)
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
        set @data    = date_format(now(), '%Y%m%d%H%i%s');

        while @i <= @limite do
            set @r = fn_get_elemento_por_indice(sp_in_str_emails, '|', @i);

            if 0 != instr(@r, ':') then
                set @nome  = fn_get_elemento_por_indice(@r, ':', 1);
                set @email = fn_get_elemento_por_indice(@r, ':', 2);
            else
                set @nome  = fn_get_elemento_por_indice(@r, ':', 1);
                set @email = fn_get_elemento_por_indice(@r, ':', 1);
            end if;

            set @hash = concat(
                 sp_in_id_empresa
                ,'_'
                ,fn_regex_replace('[^[:alnum:]]', '', @email)
                ,'_'
                ,@data
            );

            insert ignore into email
            values(
                null,
                sp_in_id_grupo,
                sp_in_id_empresa,
                TRIM(@nome),
                TRIM(@email),
                @hash,
                NOW(),
                1
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

    select sp_out_int_status as int_status,
            sp_out_str_status as str_status
    ;
#-------fim mapeamento dos status-----------------------------------------#
END