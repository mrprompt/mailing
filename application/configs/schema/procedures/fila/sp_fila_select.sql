-- --------------------------------------------------------------------------------
-- Routine DDL
-- --------------------------------------------------------------------------------
DELIMITER $$

DROP PROCEDURE IF EXISTS `sp_fila_select` $$

CREATE PROCEDURE `sp_fila_select`(
     in  sp_in_id_status        tinyint
    ,in  sp_in_id_status_novo  tinyint
    ,out sp_out_int_status      tinyint(1)
    ,out sp_out_str_status      varchar(50)
)
begin
#-------documentacao----------------------------------------------------#
/*
autor: Thiago Paes
entradas:
    sp_in_id_status
    sp_in_id_status_novo

saidas:
	int_status
		codigo do status da Solicitação
	str_status
		descricao do status da Solicitação
descricao:
	Esta SP tem como objetivo listar os e-mails que estão na fila de envio
    de uma determinada campanha.

retorno:


*/
#-------documentacao------------------------------------------------------#
#-------declaracoes iniciais----------------------------------------------#
    declare sp_entradas_validas boolean;
    declare empresa integer(11);
    declare empresa_nome varchar(255);
    declare empresa_email varchar(255);
    declare campanha integer(11);
    declare campanha_titulo varchar(255);
    declare email integer(11);
    declare email_nome varchar(255);
    declare email_prioridade integer(11);
    declare email_titulo varchar(255);
    declare email_destino varchar(255);
    declare email_conteudo text;
    declare email_hash varchar(255);
    declare status integer(11);
    declare status_nome varchar(255);
    declare done integer default 0;
    declare fila cursor for
        select STRAIGHT_JOIN
               e.id_empresa,
               e.str_nome as str_empresa,
               e.str_email as str_empresa_email,
               f.id_campanha,
               f.id_fila,
               f.id_prioridade,
               t.str_titulo,
               m.str_nome,
               m.str_email,
               t.str_corpo,
               f.str_hash
        from fila f
        inner join campanha c on c.id_campanha = f.id_campanha
        inner join empresa e on c.id_empresa = e.id_empresa
        inner join email m on m.id_email = f.id_email
        inner join template t on t.id_template = c.id_template
        where f.id_status = sp_in_id_status
        and   c.dat_inicio <= now()
        and   c.dat_fim >= now()
        and   c.int_status in ('1', '2', '3')
        limit 1000;
    declare continue handler for sqlstate '02000' set done = 1;
#-------fim declaracoes iniciais------------------------------------------#

#-------validacao das entrada---------------------------------------------#
    set sp_entradas_validas =
        sp_in_id_status > 0
    &&  sp_in_id_status_novo > 0
    ;
#-------fim validacao das entrada-----------------------------------------#

#-------procedimento------------------------------------------------------#
    if sp_entradas_validas then
        set max_heap_table_size=8467318272;

        drop table if exists fila_tmp;

        create temporary table fila_tmp (
            id_fila integer(11),
            id_prioridade integer(11),
            str_empresa varchar(255),
            str_empresa_email varchar(255),
            id_campanha integer(11),
            str_titulo varchar(255),
            str_email varchar(255),
            str_corpo varchar(48144),
            str_hash varchar(255),
            primary key (id_fila),
            index prioridade (id_prioridade)
        ) engine = memory;

        open fila;
        repeat fetch fila into empresa,
                               empresa_nome,
                               empresa_email,
                               campanha,
                               email,
                               email_prioridade,
                               email_titulo,
                               email_nome,
                               email_destino,
                               email_conteudo,
                               email_hash;
            if not done then
                set @hoje   = date_format(now(), '%d/%m/%Y');
                set @hora   = date_format(now(), '%H:%i');

                set @titulo = email_titulo;
                set @titulo = replace(@titulo, '{$nome}',   email_nome);
                set @titulo = replace(@titulo, '{$hoje}',   @hoje);
                set @titulo = replace(@titulo, '{$email}',  email_destino);

                set @corpo = email_conteudo;
                set @corpo = replace(@corpo, '{$nome}',     email_nome);
                set @corpo = replace(@corpo, '{$hoje}',     @hoje);
                set @corpo = replace(@corpo, '{$email}',    email_destino);

                insert into fila_tmp values(
                    email,
                    email_prioridade,
                    empresa_nome,
                    empresa_email,
                    campanha,
                    @titulo,
                    email_destino,
                    convert(@corpo using utf8),
                    email_hash
                );
            end if;
        until done end repeat;
        close fila;

        select *
        from fila_tmp
        order by id_prioridade desc;

        update fila f
        inner join fila_tmp t on f.id_fila = t.id_fila
        set f.id_status = sp_in_id_status_novo
        where f.id_status = sp_in_id_status;

        drop table if exists fila_tmp;

        set sp_out_int_status = 0;
    else
            set sp_out_int_status = 1;
    end if;
#-------fim procedimento--------------------------------------------------#

#-------mapeamento dos status---------------------------------------------#
    set sp_out_str_status =
        case sp_out_int_status
            when 0 then 'sp_fila_select: Solicitação efetuada com sucesso.'
            when 1 then 'sp_fila_select: Entradas inválidas.'
            else 'sp_fila_select: Status nao inicializado ou nao mapeado.'
        end;
#-------fim mapeamento dos status-----------------------------------------#
END