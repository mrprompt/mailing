<?php
/**
 *
 * @author      Thiago Paes <mrprompt@gmail.com>
 */
class Admin_TemplatesController extends Zend_Controller_Action
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

        $this->_helper
             ->layout
             ->setLayout('admin');
    }

    /**
     * Início
     *
     * Renderizo para a listagem
     */
    public function indexAction()
    {
        // action body
        try {
            $template  = new Template();
            $empresa   = $this->_session->empresa->id_empresa;
            $pagina    = $this->_getParam('pagina', 1);

            $this->view->templates = $template->lista($empresa, $pagina);
        } catch (Exception $e) {
            $mensagem = array('error' => 'Ocorreu um erro recuperando seus templates.');
            $this->_helper->flashMessenger($mensagem);
            $this->_redirect('/admin/campanhas');
        }
    }

    /**
     * Editar
     *
     * Cria/Abre um template
     */
    public function editarAction()
    {
        // action body
        $form = new Admin_Form_Template($this->_session->empresa->id_empresa);

        if ($this->_getParam('id')) {
            $template = new Template();
            $busca = $template->find($this->_getParam('id'))
                              ->current()
                              ->toArray();

            $form->populate($busca);
        }

        if ($this->_request->isPost()) {
            $data = $this->_request->getPost();

            if ($form->isValid($data)) {
                $obj_template = new stdClass();
                $obj_template->id      = (!empty($data['id_template']) ? $data['id_template'] : null);
                $obj_template->empresa = $this->_session->empresa->id_empresa;
                $obj_template->titulo  = $data['str_titulo'];
                $obj_template->nome    = $data['str_nome'];
                $obj_template->corpo   = $data['str_corpo'];

                $template = new Template();
                $template->salva($obj_template);

                $mensagem = array('success' => 'Template salvo.');
                $this->_helper
                     ->flashMessenger($mensagem);

                $this->_redirect('/admin/templates');
            } else {
                $this->_helper
                     ->flashMessenger(array('error', $form->getErrors()));
            }
        }

        $this->view->form = $form;
    }

    public function apagarAction()
    {
        $template = new Template;

        $where = array(
            $template->getAdapter()
                     ->quoteInto('id_template = ?', array($this->_getParam('id'))),
            $template->getAdapter()
                     ->quoteInto('id_empresa = ?', array($this->_session
                                                              ->empresa
                                                              ->id_empresa))
        );

        $template->delete($where);

        $mensagem = array('success' => 'Template removido com sucesso.');

        $this->_helper
             ->flashMessenger($mensagem);

        $this->_redirect('/admin/templates');
    }
}
