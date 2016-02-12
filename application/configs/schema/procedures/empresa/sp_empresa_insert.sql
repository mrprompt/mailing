-- --------------------------------------------------------------------------------
-- Routine DDL
-- --------------------------------------------------------------------------------
DELIMITER $$

DROP PROCEDURE IF EXISTS `sp_empresa_insert` $$

CREATE PROCEDURE `sp_empresa_insert`(
     in  sp_in_str_nome         varchar(255)
    ,in  sp_in_str_email        varchar(200)
    ,in  sp_in_str_senha        varchar(100)
    ,in  sp_in_int_telefone     varchar(20)
    ,in  sp_in_int_cep          varchar(10)
    ,out sp_out_int_status      tinyint
    ,out sp_out_str_status      varchar(120)
)
begin
#-------documentacao----------------------------------------------------#
/*
autor: Thiago Paes
entradas:
    sp_in_str_nome
    sp_in_str_email
    sp_in_int_telefone
    sp_in_int_cep

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
            0 != length(sp_in_str_nome)
        &&  0 != fn_valida_email(sp_in_str_email)
        &&  0 != length(sp_in_str_senha)
        && 10 = length(fn_somente_numeros(sp_in_int_telefone))
        &&  8 = length(fn_somente_numeros(sp_in_int_cep))
    ;
#-------fim validacao das entrada-----------------------------------------#

#-------procedimento------------------------------------------------------#
    if sp_entradas_validas then
        #-------validação de dados duplicados-------------------------------------#
        set @novo = true;

        if (0 != (select count(id_usuario) from usuario where str_email = sp_in_str_email))
        then
            set sp_out_int_status   = 2;
            set @novo               = false;
        end if;
        #-------fim validação de dados duplicados---------------------------------#

        if @novo = true
        then
            -- insiro a empresa
            insert into empresa
            values(null
                  ,sp_in_str_nome
                  ,sp_in_str_email
                  ,fn_somente_numeros(sp_in_int_telefone)
                  ,fn_somente_numeros(sp_in_int_cep)
                  ,substr(sha1(concat(now(), sp_in_str_email)), 1, 30)
                  ,substr(sha1(concat(now(), sp_in_str_nome, sp_in_int_cep)), 1, 30)
                  ,now()
                  ,'1'
            );
            set @empresa = last_insert_id();

            -- crio o usuário de acesso
            call sp_usuario_insert(
                 @empresa
                ,sp_in_str_nome
                ,sp_in_str_email
                ,sp_in_str_senha
                ,@1
                ,@2
            );

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
            when 2 then 'Já existe um usuário utilizando este e-mail.'
            else 'Status nao inicializado ou nao mapeado.'
        end;

    select sp_out_int_status as int_status,
            sp_out_str_status as str_status
    ;
#-------fim mapeamento dos status-----------------------------------------#
END