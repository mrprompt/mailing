<?php
/**
 *
 * @author      Thiago Paes <mrprompt@gmail.com>
 */
class Api_UsuariosController extends Zend_Controller_Action
{
    /**
     * Limite de resultados da busca
     *
     * @var integer
     */
    const LIMITE  = 15;

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

    public function indexAction()
    {
        // action body
    }

    public function habilitarAction()
    {
        // action body
    }

    public function apagarAction()
    {
        // action body
    }
}
