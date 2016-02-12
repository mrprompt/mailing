<?php
/**
 * Tabela de template
 *
 * @author      Thiago Paes <mrprompt@gmail.com>
 */
class Template extends Zend_Db_Table_Abstract
{
    /**
     * nome da tabela
     *
     * @var string
     */
    protected $_name = 'template';

    /**
     * chave primaria
     *
     * @var string
     */
    protected $_primary = 'id_template';

    /**
     * Relacionamentos
     *
     * @var type
     */
    protected $_referenceMap = array(
        'Empresa'   => array(
            'columns'       => array('id_empresa'),
            'refTableClass' => 'Empresa',
            'refColumns'    => array('id_empresa'),
        ),
    );

    protected $_dependentTables = array(
        'Campanha',
    );

    /**
     *
     * @param stdClass $template
     * @return mixed
     */
    protected function _insere(stdClass $template)
    {
        $data = array(
            'id_template'     => null,
            'id_empresa'      => $template->empresa,
            'str_nome'        => $template->nome,
            'str_titulo'      => $template->titulo,
            'str_corpo'       => $template->corpo,
            'dat_criacao'     => date('Y-m-d H:i:s'),
            'dat_atualizacao' => date('Y-m-d H:i:s'),
        );

        return $this->insert($data);
    }

    /**
     *
     * @param stdClass $template
     * @return mixed
     */
    protected function _atualiza(stdClass $template)
    {
        $data = array(
            'str_nome'    => $template->nome,
            'str_titulo'  => $template->titulo,
            'str_corpo'   => $template->corpo,
            'dat_atualizacao' => date('Y-m-d H:i:s'),
        );

        $where = array(
            $this->getAdapter()
                 ->quoteInto('id_empresa = ?', array($template->empresa)),
            $this->getAdapter()
                 ->quoteInto('id_template = ?', array($template->id)),
        );

        return $this->update($data, $where);
    }

    /**
     *
     * @param stdClass $template
     * @return mixed
     */
    public function salva(stdClass $template)
    {
        if (null === $template->id) {
            $retorno = $this->_insere($template);
        } else {
            $retorno = $this->_atualiza($template);
        }

        return $retorno;
    }

    /**
     *
     * @param integer $empresa
     * @param integer $pagina
     */
    public function lista($empresa, $pagina = 1)
    {
        $select = $this->select()
                       ->where('id_empresa = ?', $empresa);

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
     * @param integer $empresa
     * @return mixed
     */
    public function buscaDefault($empresa)
    {
        $select = $this->select()
                       ->where('id_empresa = ?', $empresa)
                       ->where('int_default = 1')
                       ->limit(1);

        return $this->fetchRow($select);
    }
}