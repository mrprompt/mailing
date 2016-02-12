<?php
/**
 *
 * @author      Thiago Paes <mrprompt@gmail.com>
 */
class Api_EmailsController extends Zend_Controller_Action
{
    /**
     * Limite de resultados da busca
     *
     * @var integer
     */
    const LIMITE  = 100;

    /**
     * Quantas páginas mostrar na paginação
     *
     * @var integer
     */
    const PAGINAS = 5;

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
     * Lista os e-mails cadastrados
     */
    public function indexAction()
    {
        $parametros = $this->_request->getPost();

        $empresa = $this->_session->empresa->id_empresa;
        $pagina  = $parametros['pagina'];

        $email   = new Email();
        $emails  = $email->lista($empresa, self::LIMITE, $pagina, self::PAGINAS);

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

    /**
     * Editar
     *
     */
    public function editarAction()
    {
        $form = new Admin_Form_Email;

        if (isset($this->_session->formEmailCampos)) {
            $campos = $this->_session->formEmailCampos;

            $form->isValid($campos);
            $form->populate($campos);

            unset($this->_session->formEmailCampos);
        }

        $this->view->form = $form;
    }

    /**
     * Salva os dados enviados pela action Editar
     *
     */
    public function salvarAction()
    {
        $form = new Admin_Form_Email;

        if ($this->_request->isPost()) {
            $data = $this->_request->getPost();

            if ($form->isValid($data)) {
                try {
                    $obj = new stdClass();
                    $obj->empresa  = $this->_session->empresa;
                    $obj->email    = (!empty($data['nome']) ? $data['nome'] : $data['email']) . ':' . $data['email'];

                    $email = new Email;
                    $email->insere($obj);

                    $mensagem = array('success' => 'Salvo com sucesso.');
                    $this->_helper->flashMessenger($mensagem);
                } catch (Exception $e) {
                    $mensagem = array('error' => $e->getMessage());
                    $this->_helper->flashMessenger($mensagem);
                }
            } else {
                $this->_session->formEmailCampos = $data;
                $this->_session->retorno = $form->getErrors();

                $mensagem = array('error', $form->getErrors());
            }

            $this->_session->retorno = Zend_Json::encode($mensagem);
        }

        $this->view->form = $form;
    }

    /**
     * Importar
     *
     */
    public function importarAction()
    {
        $form = new Admin_Form_EmailImportacao;

        if ($this->_request->isPost()) {
            $data = $this->_request->getPost();

            if ($form->isValid($data)) {

            }

            $form->populate($data);
        }

        $this->view->form = $form;
    }

    /**
     * Exportar
     *
     */
    public function exportarAction()
    {

    }

    public function apagarAction()
    {
        if ($this->_request->isPost()) {
            $data = $this->_request->getPost();

            $email  = new Email;
            $email->apaga($this->_session->empresa, implode('|', $data['emails']));

            $mensagem = array('success' => 'E-mails removidos com sucesso.');
            $this->_helper->flashMessenger($mensagem);
        }
    }
}
