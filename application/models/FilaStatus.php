<?php
/**
 * Tabela de status
 *
 * @author      Thiago Paes <mrprompt@gmail.com>
 */
class FilaStatus extends Zend_Db_Table_Abstract
{
    /**
     * nome da tabela
     *
     * @var string
     */
    protected $_name = 'fila_status';

    /**
     * chave prim�ria
     *
     * @var string
     */
    protected $_primary = 'id_status';

    /**
     * Tabelas relacionadas
     *
     * @var mixed
     */
    protected $_dependentTables = array(
        'Fila',
        'Campanha',
    );
}