<?php
/**
 * Mapper para a tabela de admin
 *
 * @author      Thiago Paes <mrprompt@gmail.com>
 */
class Usuario extends Zend_Db_Table_Abstract
{
    /**
     * nome da tabela
     *
     * @var string
     */
    protected $_name = 'usuario';

    /**
     * chave prim�ria
     *
     * @var string
     */
    protected $_primary = 'id_usuario';

    protected $_referenceMap = array(
        'Empresa'   => array(
            'columns'       => array('id_empresa'),
            'refTableClass' => 'Empresa',
            'refColumns'    => array('id_empresa'),
        ),
    );

    /**
     * Autentica o usuário
     *
     * @param string $email
     * @param string $senha
     */
    public function login($email, $senha)
    {
        $query = "
        call sp_usuario_login(
             ?  # e-mail
            ,?  # senha
            ,@1 # status
            ,@2 # mensagem
        );";

        $param = array(
            $email,
            $senha,
        );

        $stmt = $this->getAdapter()
                     ->query($query, $param);
        $result = $stmt->fetchObject();

        if ($result->int_status == '0') {
            // recupero o resultset com os dados do usuário
            $stmt->nextRowset();
            $usuario = $stmt->fetchObject();

            // Recupero a emprsea que o usuário está vinculada
            $stmt->nextRowset();
            $empresa = $stmt->fetchObject();

            Zend_Registry::get('Zend_Session')->empresa = $empresa;
            Zend_Registry::get('Zend_Session')->usuario = $usuario;

            return true;
        } else {
            throw new Exception($result->str_status);
        }
    }

    /**
     *
     * @param integer $pagina
     * @param integer $empresa
     */
    public function lista($pagina = 1, $empresa = null)
    {
        $select = $this->select()
                       ->setIntegrityCheck(false)
                       ->from(array('u' => 'usuario'),
                              array('*'));

        if ($empresa !== null) {
            $select->where('u.id_empresa = ?', $empresa);
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
        call sp_usuario_insert(
             ?  # id da empresa
            ,?  # nome
            ,?  # email
            ,?  # senha
            ,@1
            ,@2
        );";
        $params = array(
            $email->empresa,
            $email->nome,
            $email->email,
            $email->senha
        );

        $retorno_emails = $this->getAdapter()
                               ->query($query, $params)
                               ->fetch();

        if ($retorno_emails['int_status'] != 0) {
            throw new Exception($retorno_emails['str_status']);
        }

        return true;
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
                        ->quoteInto('id_usuario = ?', array($email->id));

        $campos = array(
            'str_nome'   => $email->nome,
            'str_email'  => $email->email,
        );

        if (isset($email->senha)) {
            $campos['str_senha'] = sha1($email->senha);
        }

        return $this->update($campos, $where);
    }

    /**
     *
     * @param string $id ID do(s) e-mail(s) - separados por pipe
     */
    public function apaga($empresa, $id)
    {
        $query = "
        call sp_usuario_delete(
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