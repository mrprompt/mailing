<?php
/**
 * Tabela de campanhas
 *
 * @author      Thiago Paes <mrprompt@gmail.com>
 */
class Campanha extends Zend_Db_Table_Abstract
{
    /**
     * nome da tabela
     *
     * @var string
     */
    protected $_name = 'campanha';

    /**
     * primary key
     *
     * @var string
     */
    protected $_primary = 'id_campanha';

    /**
     * Chaves estrangeiras
     *
     * @var array
     */
    protected $_referenceMap = array(
        'Empresa'   => array(
            'columns'       => array('id_empresa'),
            'refTableClass' => 'Empresa',
            'refColumns'    => array('id_empresa'),
        ),
        'Template'   => array(
            'columns'       => array('id_template'),
            'refTableClass' => 'Template',
            'refColumns'    => array('id_template'),
        ),
        'FilaPrioridade'   => array(
            'columns'       => array('id_prioridade'),
            'refTableClass' => 'FilaPrioridade',
            'refColumns'    => array('id_prioridade'),
        ),
    );

    /**
     * Tabelas ligadas
     *
     * @var mixed
     */
    protected $_dependentTables = array(
        'Fila',
    );

    /**
     * Cria uma campanha
     *
     * @param integer id_campanha
     * @param integer id_empresa
     * @param integer id_template
     * @param integer id_prioridade
     * @param string  str_titulo
     * @param datetime dat_inicio
     * @param datetime dat_fim
     * @return boolean
     */
    public function salva()
    {
        try {
            if (!empty($this->id_campanha)) {
                $this->update();
            } else {
                $this->id_campanha = $this->insert();
            }
        } catch (Exception $e) {
            throw $e;
        }
    }

    /**
     * Cria uma campanha
     *
     * @param integer id_empresa
     * @param integer id_template
     * @param integer id_prioridade
     * @param string  str_titulo
     * @param datetime dat_inicio
     * @param datetime dat_fim
     * @return boolean
     */
    public function insert()
    {
        $query = "
        call sp_campanha_insert(
             ?  # id da empresa
            ,?  # id do template
            ,?  # id_prioridade
            ,?  # titulo da campanha
            ,?  # data de início
            ,?  # data de limite
            ,@1 # id de status do retorno
            ,@2 # string de status do retorno
        );";

        $params = array(
            $this->id_empresa,
            $this->id_template,
            $this->id_prioridade,
            $this->str_titulo,
            $this->dat_inicio,
            $this->dat_fim
        );

        $retorno_campanha = $this->getAdapter()
                                 ->query($query, $params)
                                 ->fetch();

        if ($retorno_campanha->id_status != 0) {
            throw new Exception($retorno_campanha->str_status);
        }

        $this->id_campanha = $retorno_campanha->id_campanha;

        return true;
    }

    /**
     * Atualiza uma campanha
     *
     * @param integer $id_campanha
     * @param integer $id_empresa
     * @param integer $id_template
     * @param integer $id_prioridade
     * @param string  $str_titulo
     * @param datetime $dat_inicio
     * @param datetime $dat_fim
     * @return boolean
     */
    public function update()
    {
        $query = "
        call sp_campanha_update(
             ?  # id da campanha
            ,?  # id da empresa
            ,?  # id do template
            ,?  # id da prioridade
            ,?  # titulo da campanha
            ,?  # data de início
            ,?  # data de limite
            ,@1 # id de status do retorno
            ,@2 # string de status do retorno
        );";

        $params = array(
            $this->id_campanha,
            $this->id_empresa,
            $this->id_template,
            $this->id_prioridade,
            $this->str_titulo,
            $this->dat_inicio,
            $this->dat_fim
        );

        $retorno = $this->getAdapter()
                        ->query($query, $params)
                        ->fetch();

        if ($retorno->int_status != 0) {
            throw new Exception($retorno->str_status);
        }

        return true;
    }

    /**
     * Apaga uma campanha
     *
     * @param integer $id_campanha
     * @param integer $id_empresa
     * @return boolean
     */
    public function delete()
    {
        $query = "
        call sp_campanha_delete(
             ?  # id da campanha
            ,?  # id da empresa
            ,@1 # codigo de status
            ,@2 # string de status
        );
        select @1 as int_status,
               @2 as str_status;
        ";

        $params = array(
            $this->id_campanha,
            $this->id_empresa,
        );

        $result = $this->getAdapter()
                       ->query($query, $params)
                       ->fetch();

        if ($result['int_status'] != '0') {
            throw new Exception($result['str_status']);
        }

        return true;
    }

    /**
     *
     * @param integer $empresa
     * @param integer $pagina
     * @return Zend_Paginator
     */
    public function lista()
    {
        $this->getAdapter()
            ->query('set session sql_mode="STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION"');

        $select = $this->select()
                       ->setIntegrityCheck(false)
                       ->from(array('c' => 'campanha'),
                              array('*', '(select count(id_fila) from fila where id_campanha = c.id_campanha) as int_emails'))
                       ->where('c.id_empresa = ?', $this->id_empresa)
                       ->where('c.int_status in("1","2","3")')
                       ->group('c.id_campanha')
                       ->order('c.dat_atualizacao DESC');

        $adapter   = new Zend_Paginator_Adapter_DbTableSelect($select);
        $paginator = new Zend_Paginator($adapter);
        $paginator->setItemCountPerPage(PAGINACAO_LIMITE);
        $paginator->setPageRange(PAGINACAO_LINKS);
        $paginator->setCurrentPageNumber($this->int_pagina);

        return $paginator;
    }

    /**
     * Recupera o status da campanha
     *
     * @param integer $id_campanha
     * @return mixed
     */
    public function status()
    {
        $query = "
        call sp_campanha_status(
             ?  # campanha
            ,@1
            ,@2
        );";
        $params = array(
            $this->id_campanha
        );
        $retorno = $this->getAdapter()
                        ->query($query, $params)
                        ->fetch();

        return $retorno['status'];
    }
}