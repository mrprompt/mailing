<?php
/**
 * Tabela de prioridade de envio
 *
 * @author      Thiago Paes <mrprompt@gmail.com>
 */
class FilaPrioridade extends Zend_Db_Table_Abstract
{
    /**
     * nome da tabela
     *
     * @var string
     */
    protected $_name = 'fila_prioridade';

    /**
     * chave prim�ria
     *
     * @var string
     */
    protected $_primary = 'id_prioridade';

    /**
     * Tabelas relacionadas
     *
     * @var mixed
     */
    protected $_dependentTables = array(
        'Fila',
    );
}