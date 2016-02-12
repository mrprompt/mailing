<?php
/**
 * Tabela de emails
 *
 * @author      Thiago Paes <mrprompt@gmail.com>
 */
class Email extends Zend_Db_Table_Abstract
{
    /**
     * nome da tabela
     *
     * @var string
     */
    protected $_name = 'email';

    /**
     * chave prim�ria
     *
     * @var string
     */
    protected $_primary = 'id_email';

    protected $_referenceMap = array(
        'Empresa'   => array(
            'columns'       => array('id_empresa'),
            'refTableClass' => 'Empresa',
            'refColumns'    => array('id_empresa'),
        ),
        'EmailGrupo'   => array(
            'columns'       => array('id_email_grupo'),
            'refTableClass' => 'EmailGrupo',
            'refColumns'    => array('id_email_grupo'),
        ),
    );

    /**
     *
     * @param integer $empresa
     * @param integer $pagina
     * @param integer $grupo
     */
    public function lista($empresa, $pagina = 1, $grupo = null)
    {
        $select = $this->select()
                       ->setIntegrityCheck(false)
                       ->from(
                               array('e' => 'email'),
                               array('*'))
                       ->joinInner(
                               array('g' => 'email_grupo'),
                               'e.id_email_grupo = g.id_email_grupo',
                               array('str_nome as str_grupo'))
                       ->where('e.id_empresa = ?', $empresa)
                       ->where('e.int_status in(1)');

        if ($grupo !== null) {
            $select->where('g.id_email_grupo = ?', $grupo);
        }

        $adapter   = new Zend_Paginator_Adapter_DbTableSelect($select);
        $paginator = new Zend_Paginator($adapter);
        $paginator->setItemCountPerPage(PAGINACAO_LIMITE);
        $paginator->setPageRange(PAGINACAO_LINKS);
        $paginator->setCurrentPageNumber($pagina);

        unset($adapter, $select);

        return $paginator;
    }

    /**
     *
     * @param stdClass $email
     */
    public function insere(stdClass $email)
    {
        $query = "
        call sp_email_insert(
             ?  # id da empresa
            ,?  # id do grupo
            ,?  # e-mails (separados por pipe)
            ,@1
            ,@2
        );";
        $params = array(
            $email->empresa,
            $email->grupo,
            $email->email,
        );

        $retorno_emails = $this->getAdapter()
                               ->query($query, $params)
                               ->fetch();

        return $retorno_emails;
    }

    /**
     *
     * @param stdClass $email
     */
    public function atualiza(stdClass $email)
    {
        $where = array();
        $where[] = $this->getAdapter()
                         ->quoteInto('id_empresa = ?', array($email->empresa));
        $where[] = $this->getAdapter()
                        ->quoteInto('id_email = ?', array($email->id));

        $campos = array(
            'str_nome'   => $email->nome,
            'str_email'  => $email->email,
        );

        return $this->update($campos, $where);
    }

    /**
     *
     * @param string $id ID do(s) e-mail(s) - separados por pipe
     */
    public function apaga($empresa, $id)
    {
        $query = "
        call sp_email_delete(
             ?  # id da empresa
            ,?  # e-mails (separados por pipe)
            ,@1
            ,@2
        );";
        $params = array(
            $empresa,
            $id,
        );

        $retorno_emails = $this->getAdapter()
                               ->query($query, $params)
                               ->fetch();

        return $retorno_emails;
    }
}