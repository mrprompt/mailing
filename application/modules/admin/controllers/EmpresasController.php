<?php
/**
 *
 * @author      Thiago Paes <mrprompt@gmail.com>
 */
class Admin_EmpresasController extends Zend_Controller_Action
{
    /**
     * @var Zend_Session_Namespace
     *
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

        if ($this->_session->usuario->id_usuario_nivel != 1) {
            $mensagem = array('error' => 'Acesso negado.');
            $this->_helper->flashMessenger($mensagem);

            $this->_redirect('/admin');
        }

        $this->_helper
             ->layout
             ->setLayout('admin');
    }

    /**
     * Tela inicial
     *
     * Lista as empresas cadastradas
     *
     */
    public function indexAction()
    {
        // action body
        $empresa  = new Empresa;
        $pagina   = $this->_getParam('pagina', 1);
        $empresas = $empresa->lista(PAGINACAO_LIMITE, $pagina, PAGINACAO_LINKS);

        $this->view->empresas = $empresas;
    }

    /**
     * Editar
     *
     * Abre uma empresa para edição
     */
    public function editarAction()
    {
        $form = new Admin_Form_Empresa;

        if ($this->_getParam('empresa')) {
            $empresa = new Empresa();
            $linha   = $empresa->find($this->_getParam('empresa'))
                               ->current();

            $form->populate($linha->toArray());
        }

        if ($this->_request->isPost()) {
            $data = $this->_request->getPost();

            if ($form->isValid($data)) {
                try {
                    $obj = new stdClass();
                    $obj->id            = $this->_getParam('empresa', null);
                    $obj->nome          = $data['str_nome'];
                    $obj->email         = $data['str_email'];
                    $obj->telefone      = $data['int_telefone'];
                    $obj->cep           = $data['int_cep'];

                    if (!$this->_getParam('empresa')) {
                        $obj->senha     = $data['str_senha'];

                        unset($obj->id);
                    }

                    $empresa = new Empresa();
                    $empresa->salva($obj);

                    $mensagem = array('success' => 'Salvo com sucesso.');
                } catch (Exception $e) {
                    $mensagem = array('error' => $e->getMessage());
                }

                $this->_helper->flashMessenger($mensagem);
                $this->_redirect('/admin/empresas');
            }

            $form->populate($data);
        }

        $this->view->form = $form;
    }

    /**
     * Apagar
     *
     * Remove uma empresa
     *
     */
    public function apagarAction()
    {
        // action body
        $id_empresa = $this->_getParam('empresa');
        $tb_empresa = new Empresa();

        $where = $tb_empresa->getAdapter()
                            ->quoteInto('id_empresa = ?', $id_empresa);

        $tb_empresa->delete($where);

        $mensagem = array(
            'success' => 'Empresa removida com sucesso.'
        );
        $this->view->retorno = $mensagem;
    }

    /**
     * Se loga como a empresa indicada para criar campanhas e etc
     *
     */
    public function logarAction()
    {
        // action body
        $id_empresa = $this->_getParam('empresa');
        $tb_empresa = new Empresa();

        $this->_session->empresa = $tb_empresa->find($id_empresa)->current();

        $mensagem = array('success' => 'Logado.');
        $this->view->retorno = $mensagem;

        $this->_redirect('/');
    }
}
