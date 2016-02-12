<?php
class Zend_View_Helper_Mensagem extends Zend_View_Helper_Abstract
{
    public function Mensagem()
    {
        $messages = Zend_Controller_Action_HelperBroker::getStaticHelper('FlashMessenger')->getMessages();
        $output   = '';

        if (!empty($messages)) {
            foreach ($messages as $message) {
                $output = '<div id="messages" class="alert alert-' . key($message) . '">'
                        . current($message)
                        . '</div>';
            }
        }


        return $output;
    }
}
