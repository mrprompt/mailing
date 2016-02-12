<?php
/**
 * Helper de formatação de data para o formato brasileiro
 *
 * @author Thiago Paes <mrprompt@gmail.com>
 */
class Zend_View_Helper_Data extends Zend_View_Helper_Abstract
{
    public function data($data)
    {
        $dt = new DateTime($data);
        return $dt->format('d/m/Y');
    }
}
