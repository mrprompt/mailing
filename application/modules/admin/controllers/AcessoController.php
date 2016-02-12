<?php
/**
 * Acesso ao admin
 *
 * @author      Thiago Paes <mrprompt@gmail.com>
 */
class Admin_AcessoController extends Zend_Controller_Action
{
    /**
     *
     * @var Zend_Session_Namespace
     */
    protected $_session;

    /**
     * Construtor
     */
    public function init()
    {
        /* Initialize action controller here */
        $this->_helper
             ->layout
             ->setLayout('admin');

        $this->_session = Zend_Registry::get('Zend_Session');
    }

    /**
     * Tela inicial
     *
     * Redireciono para a tela de login
     */
    public function indexAction()
    {
        if (isset($this->_session->usuario)) {
            $this->_redirect('/admin/campanhas');
        }

        $this->_redirect('/admin/acesso/login');
    }

    /**
     * Login
     *
     * Autentica o usuário
     */
    public function loginAction()
    {
        if (isset($this->_session->usuario)) {
            $this->_redirect('/admin');
        }

        $usuario = new Usuario;
        $form    = new Admin_Form_Login();

        if ($this->_request->isPost()) {
            $data = $this->_request->getPost();
            $form->populate($data);

            if ($form->isValid($data)) {
                try {
                    $usuario = new Usuario;
                    $usuario->login($data['str_email'], $data['str_senha']);

                    $msg = array('success' => 'Bem vindo.');
                } catch (Exception $e) {
                    $msg = array('error' => $e->getMessage());
                }

                $this->_helper->flashMessenger($msg);

                $this->_redirect('/admin/acesso/login');
            }
        }

        $this->view->form = $form;
    }

    /**
     * Logout
     *
     * Limpa toda a sessão, consecutivamente, deslogando o usuário
     */
    public function logoutAction()
    {
        $this->_session
             ->unsetAll();

        $this->_helper
             ->flashMessenger(array('success' => 'Até mais :)'));

        $this->_redirect('/admin/acesso/login');
    }
}
