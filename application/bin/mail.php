#!/usr/bin/env php -q
<?php
/**
 * Envio de e-mails
 *
 * @author      Thiago Paes <mrprompt@gmail.com>
 */
// caminho da app
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

// include path
set_include_path(
    implode(
        PATH_SEPARATOR,
        array(
            realpath(APPLICATION_PATH . '/../library'),
            realpath(APPLICATION_PATH . '/models'),
            get_include_path(),
        )
    )
);

// libs
require_once 'Zend/Application.php';
require_once 'Zend/Http/Client.php';
require_once 'Zend/Console/Getopt.php';
require_once 'SystemDaemon/System/Daemon.php';
require_once 'Amazon-SES-Zend-Mail-Transport/library/App/Mail/Transport/AmazonSES.php';

// Configuro o daemon
System_Daemon::setOption('usePEAR', false);
System_Daemon::setOption("appName", "mail");
System_Daemon::setOption("appDescription", "Trata a fila de e-mails.");
System_Daemon::setOption("appDir", dirname(__FILE__));
System_Daemon::setOption("appExecutable", basename(__FILE__));
System_Daemon::setOption("logVerbosity", '7');
System_Daemon::setOption("logLocation", APPLICATION_PATH . '/../log/mail.log');
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
if (isset($opts->start)) {
    // iniciando o daemon
    System_Daemon::start();

    // contador de envios diários
    $envios = array();

    while (true) {
        $data = date('Ymd');

        if (!isset($envios[$data])) {
            $envios[$data] = 0;
        }

        try {
            // leio as configurações da amazon
            $ini    = APPLICATION_PATH . '/configs/amazon.ini';
            $config = new Zend_Config_Ini($ini, APPLICATION_ENV);
            $amazon = $config->toArray();

            // data no formato exigido pela api
            $date = gmdate('D, d M Y H:i:s O');

            // Recupero o limite de envio da Amazon
            $uri    = 'https://email.us-east-1.amazonaws.com';
            $client = new Zend_Http_Client($uri);
            $client->setMethod(Zend_Http_Client::POST);
            $client->setHeaders(array(
                'Date' => $date,
                'X-Amzn-Authorization' => sprintf(
                    'AWS3-HTTPS AWSAccessKeyId=%s,Algorithm=HmacSHA256,Signature=%s',
                    $amazon['accessKey'],
                    base64_encode(hash_hmac('sha256', $date, $amazon['privateKey'], true))
                )
            ));
            $client->resetParameters();
            $client->setEncType(Zend_Http_Client::ENC_URLENCODED);
            $client->setParameterPost(array('Action' => 'GetSendQuota'));

            $response = $client->request(Zend_Http_Client::POST);

            if ($response->getStatus() != 200){
                throw new Exception($response->getBody());
            }

            $xml      = new SimpleXMLElement($response->getBody());
            $enviados = (int)$xml->GetSendQuotaResult->SentLast24Hours;
            $limite   = (int)$xml->GetSendQuotaResult->Max24HourSend;

            unset($xml, $config, $date, $ini, $client, $response);

            if ($enviados < $limite) {
                System_Daemon::log(System_Daemon::LOG_DEBUG, "Conectando a base.");
                $ini    = APPLICATION_PATH . '/configs/application.ini';

                $config = new Zend_Config_Ini($ini, APPLICATION_ENV);
                $config = $config->toArray();
                $config = $config['resources']['db']['params'];
                $config = array(
                    'host'      => $config['host'],
                    'username'  => $config['username'],
                    'password'  => $config['password'],
                    'dbname'    => $config['dbname']
                );

                $db = new Zend_Db_Adapter_Pdo_Mysql($config);
                $db->setFetchMode(Zend_Db::FETCH_OBJ);

                System_Daemon::log(System_Daemon::LOG_DEBUG, "Buscando e-mails.");
                $fila = $db->query('call sp_fila_select(1, 2, @1, @2);')
                           ->fetchAll();

                System_Daemon::log(System_Daemon::LOG_DEBUG, "Desconectando da base.");
                $db->closeConnection();

                if (0 != count($fila)) {
                    System_Daemon::log(System_Daemon::LOG_DEBUG, "Conectando ao Gateway.");

                    $smtp = new App_Mail_Transport_AmazonSES($amazon);

                    // array de status
                    $status = array(
                        'enviados' => array(),
                        'erros'    => array(),
                        'sobras'   => array(),
                    );

                    System_Daemon::log(System_Daemon::LOG_DEBUG, "Enviando.");

                    foreach ($fila as $email) {
                        if ($envios[$data] < ($limite - $enviados)) {
                            try {
                                $img = '<img src="/confirmaleitura/id/'
                                     . $email->str_hash
                                     . '" width=1 height=1/>';

                                $mail = new Zend_Mail('utf-8');
                                $mail->setBodyHtml($email->str_corpo . $img)
                                     ->setFrom($email->str_empresa_email, $email->str_empresa)
                                     ->setReplyTo($email->str_empresa_email, $email->str_empresa)
                                     ->addTo($email->str_email)
                                     ->setSubject($email->str_titulo)
                                     ->send($smtp);

                                unset($mail);

                                $status['enviados'][] = $email->id_fila;
                                $envios[$data]++;

                                System_Daemon::log(System_Daemon::LOG_DEBUG, $email->str_hash);
                            } catch (Exception $e) {
                                $status['erros'][] = $email->id_fila;

                                System_Daemon::log(System_Daemon::LOG_ERR, $e->getMessage());
                            }
                        } else {
                            $status['sobras'][] = $email->id_fila;
                        }
                    }

                    $msg = "Conectando a base.";
                    System_Daemon::log(System_Daemon::LOG_DEBUG, $msg);

                    $db->getConnection();

                    $ids = null;

                    if (0 !== count($status['enviados'])) {
                        $msg = "Atualizando mensagens enviadas.";
                        System_Daemon::log(System_Daemon::LOG_DEBUG, $msg);

                        $ids = implode(',', $status['enviados']);
                        $sql = "update fila set id_status = 3 where id_fila in({$ids});";
                        $db->query($sql);
                    }

                    if (0 !== count($status['erros'])) {
                        $msg = "Atualizando mensagens com erro.";
                        System_Daemon::log(System_Daemon::LOG_DEBUG, $msg);

                        $ids = implode(',', $status['erros']);
                        $sql = "update fila set id_status = 4 where id_fila in({$ids});";
                        $db->query($sql);
                    }

                    if (0 !== count($status['sobras'])) {
                        $msg = "Atualizando mensagens excedidas ao limite.";
                        System_Daemon::log(System_Daemon::LOG_DEBUG, $msg);

                        $ids = implode(',', $status['sobras']);
                        $sql = "update fila set id_status = 1 where id_fila in({$ids});";
                        $db->query($sql);
                    }

                    $msg = "Desconectando da base.";
                    System_Daemon::log(System_Daemon::LOG_DEBUG, $msg);

                    $db->closeConnection();

                    unset($status, $ids, $msg, $smtp);
                }

                unset($db, $fila, $config, $ini);
            }
        } catch (Exception $e) {
            $erro = $e->getMessage()
                  . ': '
                  . $e->getFile()
                  . '('
                  . $e->getLine()
                  . ')';
            System_Daemon::log(System_Daemon::LOG_ERR, $erro);

            unset($erro);
        }
    }
}

/**
 * Action : stop
 */
if(isset($opts->stop)) {
   System_Daemon::stop();
}
