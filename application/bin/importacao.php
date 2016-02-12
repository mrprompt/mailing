#!/usr/bin/env php -q
<?php
/**
 * Importação de contatos
 *
 * @author Thiago Paes <mrprompt@gmail.com>
 * @package Marketing
 * @subpackage importacao
 */
ini_set('memory_limit', -1);
ini_set('max_execution_time', -1);
set_time_limit(0);

// caminho da aplicação
defined('APPLICATION_PATH')
    || define('APPLICATION_PATH', realpath(__DIR__ . '/../../application'));

// recuperando o ambiente (production|development|testing)
defined('APPLICATION_ENV')
    || define(
        'APPLICATION_ENV', (
            getenv('APPLICATION_ENV') ?
            getenv('APPLICATION_ENV') :
            'production'
        )
    );

// intervalo da interaçãoo principal do script (em segundos)
defined('APPLICATION_INTERVAL')
    || define('APPLICATION_INTERVAL', 60);

// pasta tmp com os arquivos CSV a serem lidos
defined('APPLICATION_DIR_FILES')
    || define('APPLICATION_DIR_FILES', APPLICATION_PATH
                                     . DIRECTORY_SEPARATOR
                                     . '..'
                                     . DIRECTORY_SEPARATOR
                                     . 'tmp');

// definindo o caminho de inclus�o
set_include_path(
    implode(
        PATH_SEPARATOR,
        array(
            realpath(APPLICATION_PATH . '/../library'),
            get_include_path(),
        )
    )
);

/** Zend_Application */
require_once 'Zend/Application.php';
require_once 'SystemDaemon/System/Daemon.php';

// Create application, bootstrap, and run
$application = new Zend_Application(
    APPLICATION_ENV,
    APPLICATION_PATH . '/configs/application.ini'
);
$application->setBootstrap(APPLICATION_PATH, 'Bootstrap')
            ->bootstrap();

// Configuro o daemon
System_Daemon::setOption('usePEAR', false);
System_Daemon::setOption("appName", "importacao");
System_Daemon::setOption("appDescription", "Importa um arquivo CSV de e-mails");
System_Daemon::setOption("appDir", dirname(__FILE__));
System_Daemon::setOption("appExecutable", basename(__FILE__));
System_Daemon::setOption("logVerbosity", '7');
System_Daemon::setOption("logLocation", APPLICATION_PATH . '/../log/importacao.log');
System_Daemon::setOption("authorName", "Thiago Paes");
System_Daemon::setOption("authorEmail", "mrprompt@gmail.com");

/**
 * Setup the CLI Commands
 *
 * --help
 * --start
 * --stop
 */
try {
   $opts = new Zend_Console_Getopt(
       array(
           'help'  => 'Exibe esta ajuda.',
           'start' => 'Inicia o Daemon.',
           'stop'  => 'Encerra o Daemon',
       )
   );

   $opts->parse();
} catch (Zend_Console_Getopt_Exception $e) {
   exit($e->getMessage() ."\n\n". $e->getUsageMessage());
}

if(isset($opts->help)) {
   echo $opts->getUsageMessage();
   exit;
}

/**
 * Action : start
 */
if(isset($opts->start)) {
    try {
       System_Daemon::start();

       while (true) {
            System_Daemon::log(System_Daemon::LOG_INFO, "Checando.");

            if (file_exists(__DIR__ . '/email.sql')) {
                unlink(__DIR__ . '/email.sql');
            }

            passthru("cd " . __DIR__ . " && gawk -f ./csv2sql.gawk");

            sleep(APPLICATION_INTERVAL);
       }
    } catch (Exception $e) {
        System_Daemon::log(System_Daemon::LOG_ERR, $e->getMessage());
    }
}

/**
 * Action : stop
 */
if(isset($opts->stop)) {
   System_Daemon::stop();
}
