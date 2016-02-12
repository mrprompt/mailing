<?php
/**
 * Bootstrap
 *
 * @author      Thiago Paes <mrprompt@gmail.com>
 */
class Bootstrap extends Zend_Application_Bootstrap_Bootstrap
{
    /**
     * Iniciando o AutoLoader do Zend
     *
     * @return Zend_Application_Module_Autoloader
     */
    protected function _initAutoload()
    {
        try {
            $this->bootstrap("frontController");

            $front = $this->frontController;

            $autoloader = Zend_Loader_Autoloader::getInstance();
            $autoloader->setFallbackAutoloader(true);
            $autoloader->suppressNotFoundWarnings(true);

            $modules = $front->getControllerDirectory();
            $default = $front->getDefaultModule();

            foreach (array_keys($modules) as $module) {
                if ($module === $default) {
                    continue;
                }

                $loader = new Zend_Application_Module_Autoloader(array(
                    "namespace" => ucwords($module) . '_',
                    "basePath"  => $front->getModuleDirectory($module),
                ));

                $autoloader->pushAutoloader($loader);

                unset($loader);
            }

            return $autoloader;
        } catch (Exception $e) {
            throw $e;
        }
    }

    /**
     * Inicia a Sessao
     *
     * @return Zend_Session_Namespace
     */
    protected function _initSession()
    {
        try {
            // recupero o namespace
            $ini        = APPLICATION_PATH . '/configs/application.ini';
            $config     = new Zend_Config_Ini($ini, APPLICATION_ENV);
            $config     = $config->toArray();
            $namespace  = $config['appnamespace'];

            // inicio  sessão
            $session = new Zend_Session_Namespace($namespace, true);

            // envio para o registro para aplicação poder utilizar
            Zend_Registry::set('Zend_Session', $session);

            return $session;
        } catch (Zend_Session_Exception $e) {
            throw $e;
        }
    }
}

