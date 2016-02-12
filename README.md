# Mailing

### Pré Requisitos
- PHP 5.3+
- AWS SES
- MySQL 5.5+
- GAWK

### Instalação

- Crie o banco de dados e rode o arquivo *mailing.sql* localizado no diretório *application/configs/schema* para criar a estrutura.
- Edite os arquivos *amazon.ini* e *application.ini* para configurar corretamente os dados necessários, como acesso ao banco e etc.
- Configure um host apontando para o root para o diretório *public*, é necessário que o módulo *mod_rewrite* (no caso do Apache) 
esteja habilitado, ou aponte as rotas para o arquivo *index.php* no caso de outros servidores web.

### Rodando
Ao término da instalação, o software estará apto para utilização, os dados de acesso iniciais são:

- email: admin@localhost.localdomain
- password: mailing

### Garantia
Este software é disponibilizado *como está*, o autor não é responsável por qualquer perda ou dano consequente da utilização deste. 
Você tem total liberdade para instalar em seu próprio servidor e utilizar para quaisquer fins, com ou sem modificações na mesma.

### Contribuindo
Este é um sofware de código aberto e livre, fique a vontade para fazer um fork e contribuir com qualquer melhoria ou correção.

#### IMPORTANTE
Este é um software antigo desenvolvido pelo autor, para uso pessoal em 2011, portanto, algumas bibliotecas podem estar depreciadas.