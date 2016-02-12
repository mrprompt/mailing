<?php
/**
 * Helper de formatação de telefone
 *
 * @author Thiago Paes <mrprompt@gmail.com>
 */
class Zend_View_Helper_Telefone extends Zend_View_Helper_Abstract
{
    public function telefone($telefone)
    {
        $ddd            = substr($telefone, 0, 2);
        $operadora      = substr($telefone, 2, 4);
        $identificador  = substr($telefone, 6, 4);

        $telefone_formatado = "({$ddd}) {$operadora}-{$identificador}";

        return $telefone_formatado;
    }
}