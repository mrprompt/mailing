-- --------------------------------------------------------------------------------
-- Routine DDL
-- --------------------------------------------------------------------------------
DELIMITER $$

DROP PROCEDURE IF EXISTS `sp_usuario_insert` $$

CREATE PROCEDURE `sp_usuario_insert`(
     in  sp_in_int_empresa      integer(11)
    ,in  sp_in_str_nome         varchar(120)
    ,in  sp_in_str_email        varchar(200)
    ,in  sp_in_str_senha        varchar(100)
    ,out sp_out_int_status      tinyint(2)
    ,out sp_out_str_status      varchar(50)
)
begin
#-------documentacao----------------------------------------------------#
/*
autor: Thiago Paes
entradas:
    sp_in_int_empresa
    sp_in_str_email
    sp_in_str_senha

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
            0 != sp_in_int_empresa
        &&  0 != fn_valida_email(sp_in_str_email)
        &&  0 != length(sp_in_str_senha)
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
            -- crio o usuário de acesso
            set @query = concat(
                'insert into usuario values('
                ,'null'
                ,',\'', sp_in_int_empresa ,'\''
                ,',\'2\''
                ,',\'', sp_in_str_nome ,'\''
                ,',\'', sp_in_str_email ,'\''
                ,',\'', sha1(sp_in_str_senha) ,'\''
                ,',\'', 1 ,'\''
                ,',\'', 0 ,'\''
                ,',\'', now() ,'\''
                ,');'
            );

            prepare query from @query;
            execute query;

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