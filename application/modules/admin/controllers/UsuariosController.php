<?php
/**
 *
 * @author      Thiago Paes <mrprompt@gmail.com>
 */
class Admin_UsuariosController extends Zend_Controller_Action
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

        if (!isset($this->_session->empresa)) {
            $this->_redirect('/admin/acesso/login');
        }

        if ($this->_session->usuario->id_usuario_nivel > 2) {
            $mensagem = array('error' => 'Acesso negado.');
            $this->_helper->flashMessenger($mensagem);

            $this->_redirect('/admin');
        }

        $this->_helper
             ->layout
             ->setLayout('admin');
    }

    public function indexAction()
    {
        // action body
        $usuario = new Usuario;

        $pagina = $this->_getParam('pagina', 1);
        $empresa = $this->_session->empresa->id_empresa;

        $this->view->usuarios = $usuario->lista($pagina, $empresa);
    }

    public function apagarAction()
    {
        // action body
    }

    /**
     * Editar
     *
     */
    public function editarAction()
    {
        $form = new Admin_Form_Usuario;

        if ($this->_getParam('usuario')) {
            $empresa = new Usuario();
            $linha   = $empresa->find($this->_getParam('usuario'))
                               ->current();

            $form->populate($linha->toArray());
        }

        if ($this->_request->isPost()) {
            $data = $this->_request->getPost();

            if ($form->isValid($data)) {
                try {
                    $obj = new stdClass();
                    $obj->id            = $data['id_usuario'];
                    $obj->empresa       = $this->_session->empresa->id_empresa;
                    $obj->nome          = $data['str_nome'];
                    $obj->email         = $data['str_email'];

                    $usuario = new Usuario();

                    if (!$this->_getParam('usuario')) {
                        $obj->senha     = $data['str_senha'];

                        unset($obj->id);

                        $usuario->insere($obj);
                    } else {
                        $usuario->atualiza($obj);
                    }

                    $mensagem = array('success' => 'Salvo com sucesso.');
                    $this->_helper->flashMessenger($mensagem);
                    $this->_redirect('/admin/usuarios');
                } catch (Exception $e) {
                    $mensagem = array('error' => $e->getMessage());
                    $this->_helper->flashMessenger($mensagem);
                }
            }

            $form->populate($data);
        }

        $this->view->form = $form;
    }
}

