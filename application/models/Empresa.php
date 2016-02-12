<?php
/**
 * Tabela de empresas
 *
 * @author      Thiago Paes <mrprompt@gmail.com>
 */
class Empresa extends Zend_Db_Table_Abstract
{
    /**
     * nome da tabela
     *
     * @var string
     */
    protected $_name = 'empresa';

    /**
     * chave primária
     *
     * @var string
     */
    protected $_primary = 'id_empresa';

    /**
     * Tabelas relacionadas
     *
     * @var mixed
     */
    protected $_dependentTables = array(
        'Campanha',
        'Email',
        'Template',
        'Usuario',
    );

    /**
     *
     * @param integer $limite Limite de linhas a retornar
     * @param integer $pagina Página a ser exibida
     * @param integer $paginacao limite de páginas a ser exibidos na paginação
     */
    public function lista($limite = 10, $pagina = 1, $paginacao = 10)
    {
        $select = $this->select()
                       ->order('str_nome desc');

        $paginator = new Zend_Paginator(new Zend_Paginator_Adapter_DbTableSelect($select));
        $paginator->setItemCountPerPage($limite);
        $paginator->setPageRange($paginacao);
        $paginator->setCurrentPageNumber($pagina);

        return $paginator;
    }

    /**
     * Cadastra/atualiza os dados de uma empresa
     *
     * @param stdClass $empresa
     * @return mixed
     */
    public function salva(stdClass $empresa)
    {
        try {
            if (!empty($empresa->id)) {
                $this->_atualiza($empresa);
            } else {
                $this->_insere($empresa);
            }
        } catch (Exception $e) {
            throw $e;
        }
    }

    /**
     * Insere uma empresa no banco
     *
     * @param stdClass $empresa
     * @return mixed
     */
    private function _insere(stdClass $empresa)
    {
        $query = "
        call sp_empresa_insert(
             ?  # nome da empresa
            ,?  # e-mail de contato (será utilizado para enviar)
            ,?  # senha
            ,?  # telefone
            ,?  # cep
            ,@1
            ,@2
        );";
        $params = array(
            $empresa->nome,
            $empresa->email,
            $empresa->senha,
            $empresa->telefone,
            $empresa->cep,
        );

        $retorno = $this->getAdapter()
                        ->query($query, $params)
                        ->fetchObject();

        if ($retorno->int_status == '0') {
            return true;
        }

        throw new Exception($retorno->str_status);
    }

    /**
     * Insere uma empresa no banco
     *
     * @param stdClass $empresa
     * @return mixed
     */
    private function _atualiza(stdClass $empresa)
    {
        $query = "
        call sp_empresa_update(
             ?  # id da empresa
            ,?  # nome da empresa
            ,?  # e-mail de contato (será utilizado para enviar)
            ,?  # telefone
            ,?  # cep
            ,@1
            ,@2
        );";
        $params = array(
            $empresa->id,
            $empresa->nome,
            $empresa->email,
            $empresa->telefone,
            $empresa->cep,
        );

        $retorno = $this->getAdapter()
                        ->query($query, $params)
                        ->fetchObject();

        if ($retorno->int_status == '0') {
            return true;
        }

        throw new Exception($retorno->str_status);
    }
}