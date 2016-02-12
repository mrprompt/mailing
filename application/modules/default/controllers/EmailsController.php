<?php
/**
 *
 * @author      Thiago Paes <mrprompt@gmail.com>
 */
class Default_EmailsController extends Zend_Controller_Action
{

    public function init()
    {
        /* Initialize action controller here */
    }

    public function indexAction()
    {
        // action body
    }

    public function confirmaleituraAction()
    {
        // action body
        $hash = $this->_getParam('id', null);

        // marco a mensagem como lida
        $sql = "
        update fila
        set id_status = '5'
        where str_hash = '{$hash}'
        limit 1;";

        $fila  = new Fila();
        $fila->getAdapter()
             ->query($sql);
    }
}
