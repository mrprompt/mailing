#!/opt/local/bin/gawk -f
#  Author: Thiago Paes <mrprompt@gmail.com>
#  Notes: Importa as linhas que contenham um e-mail no arquivo CSV e importa os mesmos via mysqlimport.
#
#  @todo Utilizar conexão da aplicação
#
BEGIN {
    DB_USER="root"
    DB_PASSWORD="''"
    DB_HOST="localhost"
    DB_NAME="mailing"

    while ( ("ls `pwd`/../../tmp/*.csv 2> /dev/null" | getline arquivo ) > 0) {
        # recupero a empresa
        nome_arquivo=arquivo;
        nome_arquivo=substr(nome_arquivo, index(nome_arquivo, "contatos_"));
        gsub(/contatos_|\.csv/, "", nome_arquivo);
        split(nome_arquivo, identficadores, "_");

        # data atual
        data=strftime("%Y-%m-%d %H:%M:%S");

        # vou percorrendo as linhas do arquivo
        while ( (getline < arquivo) > 0) {
            linha=$0;

            # trato somente as linhas que contenham um e-mail válido
            if (match(linha, "((.*)+,)?[-A-z0-9.]+@[-A-z0-9.]+")) {
                # separo nome e e-mail na linha, separada por vírgula
                split(linha, l, ",");
                $1=l[1];
                $2=l[2];

                # se nao tiver nome, ponho o email
                if ($2 == "") {
                $2=$1;
                }

                # removo quebra de linha do nome e do email
                gsub(/(\r\n|\n|\r)+/, "", $1);
                gsub(/(\r\n|\n|\r)+/, "", $2);

                # gero um hash para a linha
                $3=(identficadores[1] "_" $2 "_" data);
                gsub(/[^a-zA-Z0-9_]+/, "", $3);

                # salvo no formato: nome, email, hash, data, empresa, grupo
                m=("'" $1 "', '" $2 "', '" $3 "', '" data "', '" identficadores[1] "', '" identficadores[2] "'");
                printf("%s\r\n", m) >> "email.sql";
            }
        }

        system("rm -f " arquivo);
    }

    # importo utilizando o mysqlimport
    while ( ("ls email.sql 2> /dev/null" | getline arquivo ) > 0) {
        system("mysqlimport --fields-terminated-by=', ' --fields-enclosed-by=\"'\" --lines-terminated-by=\"\\r\\n\" --ignore --user=" DB_USER " --password=" DB_PASSWORD " --local --host=" DB_HOST " --columns=\"str_nome,str_email,str_hash,dat_log,id_empresa,id_email_grupo\" " DB_NAME " email.sql && rm email.sql");
    }
}
