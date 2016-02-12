<?php
/**
 *
 * @author      Thiago Paes <mrprompt@gmail.com>
 */
class Api_CampanhasController extends Zend_Controller_Action
{
    /**
     * @var Zend_Session_Namespace
     *
     */
    protected $_session = null;

    /**
     * Construtor
     *
     */
    public function init()
    {
        /* Initialize action controller here */
        $this->_session = Zend_Registry::get('Zend_Session');

        $layout = Zend_Layout::getMvcInstance();
        $layout->disableLayout();

        $response = new Zend_Controller_Response_Http();
        $response->setHeader('Content-type', 'application/json');

        $request = new Zend_Controller_Request_Http();

        if ($request->isPost()) {
            $data = $request->getPost();

            if (false == Zend_Registry::get('Zend_Session')->empresa) {
                // logo a empresa
                $empresa = new Empresa();
                $select  = $empresa->select()
                                   ->where('str_api_chave = ?', $data['api_usuario'])
                                   ->where('str_api_segredo = ?', $data['api_senha'])
                                   ->limit(1);

                $_empresa = $empresa->fetchRow($select);

                if (isset($_empresa->id_empresa)) {
                    $session = Zend_Registry::get('Zend_Session');
                    $session->empresa = $_empresa;
                } else {
                    die(Zend_Json::encode(array('erro' => 'Usuário e senha inválidos.')));
                }
            }
        } else {
            die(Zend_Json::encode(array('erro' => 'POST requerido.')));
        }
    }

    /**
     * Index
     *
     * Tela inicial (redireciona para a listagem de empresas por enquanto)
     */
    public function indexAction()
    {
        // action body
        $parametros = $this->_request->getPost();

        $empresa   = $this->_session->empresa->id_empresa;
        $pagina    = $parametros['pagina'];

        $campanha  = new Campanha;
        $campanhas = $campanha->lista($empresa, PAGINACAO_LIMITE, $pagina, PAGINACAO_LINKS);

        echo Zend_Json::encode(array(
            'campanhas'   => Zend_Json::decode($campanhas->toJson()),
            'paginacao'   => array(
                'paginas' => $campanhas->count(),
                'atual'   => $campanhas->getCurrentPageNumber(),
                'total'   => $campanhas->getTotalItemCount(),
            )
        ));

        exit;
    }

    /**
     * Salvar
     *
     * Salva os dados de um campanha
     */
    public function salvarAction()
    {
        $data = $this->_request->getPost();

        $obj_campanha = new stdClass();
        $obj_campanha->empresa    = $this->_session->empresa->id_empresa;
        $obj_campanha->template   = $data['template'];
        $obj_campanha->titulo     = $data['titulo'];
        $obj_campanha->conteudo   = $data['conteudo'];

        $campanha    = new Campanha();
        $id_campanha = $campanha->insere($obj_campanha);

        if (isset($id_campanha->id_campanha)) {
            $mensagem = array(
                'success'     => 'Campanha criada com sucesso.',
                'id_campanha' => $id_campanha->id_campanha
            );
        } else {
            $mensagem = array('error' => 'Erro salvando campanha');
        }

        echo Zend_Json::encode($mensagem);
        exit;
    }

    public function emailsAction()
    {
        $parametros = $this->_request->getPost();

        $empresa  = $this->_session->empresa->id_empresa;
        $pagina   = $parametros['pagina'];
        $campanha = $parametros['campanha'];

        $email   = new Fila();
        $emails  = $email->lista($campanha, PAGINACAO_LIMITE, $pagina, PAGINACAO_LINKS);

        echo Zend_Json::encode(array(
            'emails'      => Zend_Json::decode($emails->toJson()),
            'paginacao'   => array(
                'paginas' => $emails->count(),
                'atual'   => $emails->getCurrentPageNumber(),
                'total'   => $emails->getTotalItemCount(),
            )
        ));

        exit;
    }
}
