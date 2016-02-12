<?php
/**
 * P�gina inicial
 *
 * @author      Thiago Paes <mrprompt@gmail.com>
 */
class Default_IndexController extends Zend_Controller_Action
{
    /**
     * construtor
     */
    public function init()
    {
        /* Initialize action controller here */
    }

    /**
     * Tela inicial
     *
     * @return void
     */
    public function indexAction()
    {
        /* action body */
        $this->_redirect('/admin');
    }
}
