<?php
/**
 * Tabela de campanhas
 *
 * @author      Thiago Paes <mrprompt@gmail.com>
 */
class Fila extends Zend_Db_Table_Abstract
{
    /**
     * nome da tabela
     *
     * @var string
     */
    protected $_name = 'fila';

    /**
     * chave prim�ria
     *
     * @var string
     */
    protected $_primary = 'id_fila';

    protected $_referenceMap = array(
        'Campanha'   => array(
            'columns'       => array('id_campanha'),
            'refTableClass' => 'Campanha',
            'refColumns'    => array('id_campanha'),
        ),
        'Email'   => array(
            'columns'       => array('id_email'),
            'refTableClass' => 'Email',
            'refColumns'    => array('id_email'),
        ),
        'FilaStatus'   => array(
            'columns'       => array('id_status'),
            'refTableClass' => 'FilaStatus',
            'refColumns'    => array('id_status'),
        ),
        'FilaPrioridade'   => array(
            'columns'       => array('id_prioridade'),
            'refTableClass' => 'FilaPrioridade',
            'refColumns'    => array('id_prioridade'),
        ),
    );

    /**
     * Recupero os e-mail da fila, conforme seu status
     *
     * @param stdClass $fila
     * @return mixed
     */
    public function getFila(stdClass $fila)
    {
        $sql  = "call sp_fila_select(
             ?   # status das mensagens da fila - vide tabela status
            ,?   # status a ser atribuído as mensagens recuperadas
            ,@1  # id de status de retorno
            ,@2  # string de status de retorno
        );";
        $params = array(
            $fila->status,
            $fila->statusNovo
        );

        $fila = $this->getAdapter()
                     ->query($sql, $params);

        $emails = $fila->fetchAll();

        $fila->nextRowset();
        $status = $fila->fetchObject();

        if ('0' != $status->int_status) {
            throw new Exception('Erros encontrados.');
        }

        return $emails;
    }

    /**
     * Atualiza o status das mensagens de uma campanha
     *
     * @param stdClass $fila
     * @return mixed
     */
    public function insere(stdClass $fila)
    {
        $sql = "
        call sp_fila_insert(?,?,?,@1,@2);
        select @1 as int_status, @2 as str_status;";

        $params = array(
            $fila->campanha,
            $fila->prioridade,
            $fila->emails
        );

        $result = $this->getAdapter()
                       ->query($sql, $params)
                       ->fetch();

        if ($result['int_status'] != '0') {
            throw new Exception($result['str_status']);
        }

        return true;
    }

    /**
     * Atualiza o status das mensagens de uma campanha
     *
     * @param stdClass $fila
     * @return mixed
     */
    public function updateStatus(stdClass $fila)
    {
        $sql  = "call sp_fila_update(
             ?   # id(s) da fila
            ,?   # status da mensagem - vide tabela status
            ,@1  # id de status de retorno
            ,@2  # string de status de retorno
        );";
        $params = array(
            (is_array($fila->emails) ? implode('|', $fila->emails) : $fila->emails),
            $fila->status
        );

        $fila = $this->getAdapter()
                     ->query($sql, $params)
                     ->fetch();

        return $fila;
    }

    /**
     * Recupero uma mensagem na fila e os dados relacionados a ela
     * pelo seu hash de envio
     *
     * @param string $hash
     * @return mixed
     */
    public function buscaPorHash($hash)
    {
        $sql  = "call sp_fila_busca_por_hash(
             ?   # hash do email
            ,@1  # id de status de retorno
            ,@2  # string de status de retorno
        );";
        $params = array(
            $hash
        );

        $fila = $this->getAdapter()
                ->query($sql, $params)
                ->fetch();

        return $fila;
    }

    /**
     *
     * @param integer $campanha
     * @param integer $pagina
     */
    public function lista($campanha, $pagina = 1)
    {
        $select = $this->select()
                       ->setIntegrityCheck(false)
                       ->from(array('f' => 'fila'), array('*'))
                       ->join(array('s' => 'fila_status'), 'f.id_status = s.id_status', array('str_status'))
                       ->join(array('e' => 'email'), 'f.id_email = e.id_email', array('*'))
                       ->where('f.id_campanha = ?', $campanha);

        $paginator = new Zend_Paginator(new Zend_Paginator_Adapter_DbTableSelect($select));
        $paginator->setItemCountPerPage(PAGINACAO_LIMITE);
        $paginator->setPageRange(PAGINACAO_LINKS);
        $paginator->setCurrentPageNumber($pagina);

        return $paginator;
    }
    
    /**
     * Insere os e-mails de um ou mais grupos na fila de envio.
     *
     * @param stdClass $fila
     * @return boolean
     */
    public function insereGrupo(stdClass $fila)
    {
        $sql    = "call sp_campanha_vincula_grupo(?, ?, @1, @2);";
        $params = array(
            $fila->campanha,
            $fila->grupos
        );

        $result = $this->getAdapter()
                       ->query($sql, $params)
                       ->fetch();

        if ($result['int_status'] != '0') {
            throw new Exception($result['str_status']);
        }

        return true;
    }    
}
