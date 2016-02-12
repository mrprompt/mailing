<?php
/**
 * Tabela de grupo de e-mail
 *
 * @author      Thiago Paes <mrprompt@gmail.com>
 */
class EmailGrupo extends Zend_Db_Table_Abstract
{
    /**
     * nome da tabela
     *
     * @var string
     */
    protected $_name = 'email_grupo';

    /**
     * chave primária
     *
     * @var string
     */
    protected $_primary = 'id_email_grupo';

    /**
     * Tabelas relacionadas
     *
     * @var mixed
     */
    protected $_dependentTables = array(
        'Email',
    );

    protected $_referenceMap = array(
        'Empresa'   => array(
            'columns'       => array('id_empresa'),
            'refTableClass' => 'Empresa',
            'refColumns'    => array('id_empresa'),
        ),
    );

    /**
     *
     * @param integer $empresa Empresa
     * @param integer $pagina Página a ser exibida
     */
    public function lista($empresa, $pagina = 1)
    {
        $select = $this->select()
                       ->from(
                           array('g' => 'email_grupo'),
                           array('*', '(select count(id_email) from email '
                                    . 'where id_email_grupo = g.id_email_grupo)'
                                    . ' as int_emails'))
                       ->where('g.id_empresa = ?', $empresa)
                       ->order('g.dat_log desc');

        $adapter   = new Zend_Paginator_Adapter_DbTableSelect($select);
        $paginator = new Zend_Paginator($adapter);
        $paginator->setItemCountPerPage(PAGINACAO_LIMITE);
        $paginator->setPageRange(PAGINACAO_LINKS);
        $paginator->setCurrentPageNumber($pagina);

        unset($adapter, $select);

        return $paginator;
    }

    public function insereEmail($grupo, $emails)
    {
        $query = "
        call sp_email_grupo_update(
            ?  # id do grupo
           ,?  # emails
           ,@1 # cod retorno
           ,@2 # status retorno
        );

        select @1 as int_status,
               @2 as str_status;
        ";
        $param = array(
            $grupo,
            $emails,
        );

        $result = $this->getAdapter()
                       ->query($query, $param)
                       ->fetch();

        if ($result['int_status'] != '0') {
            throw new Exception($result['str_status']);
        }

        return true;
    }
}