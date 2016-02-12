<?php
/**
 *
 * @author      Thiago Paes <mrprompt@gmail.com>
 */
class Admin_GruposController extends Zend_Controller_Action
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
        $grupo  = new EmailGrupo;

        $this->view->grupos = $grupo->lista(
                $this->_session->empresa->id_empresa,
                $this->_getParam('pagina', 1)
        );
    }

    /**
     * Editar
     *
     * Abre uma empresa para edição
     */
    public function editarAction()
    {
        $form = new Admin_Form_Grupo();

        if ($this->_request->isPost()) {
            $data = $this->_request->getPost();
            $data['dat_log'] = date('Y-m-d H:i:s');
            $data['id_empresa'] = $this->_session->empresa->id_empresa;

            unset($data['salvar']);

            if ($form->isValid($data)) {
                try {
                    $grupo = new EmailGrupo();
                    $grupo->insert($data);

                    $mensagem = array('success' => 'Salvo com sucesso.');
                    $this->_helper->flashMessenger($mensagem);

                    $this->_redirect('/admin/grupos');
                } catch (Exception $e) {
                    $mensagem = array('error' => $e->getMessage());
                    $this->_helper->flashMessenger($mensagem);
                }
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
        try {
            $tb_empresa = new EmailGrupo();

            $where = $tb_empresa->getAdapter()
                                ->quoteInto('id_email_grupo = ?', $this->_getParam('grupo'));

            $tb_empresa->delete($where);

            $mensagem = array('success' => 'Grupo removido.');
        } catch (Exception $e) {
            $mensagem = array('error' => $e->getMessage());
        }

        $this->_helper->flashMessenger($mensagem);
        $this->_redirect('/admin/grupos');
    }

    /**
     * Insereemail
     *
     * Insere os e-mails na campanha
     */
    public function insereemailAction()
    {
        if ($this->_request->isPost()) {
            try {
                $data = $this->_request->getPost();

                $tbCampanha = new EmailGrupo();
                $tbCampanha->insereEmail($data['grupo'], implode('|', $data['emails']));
            } catch (Exception $e) {
                $mensagem = array('error' => $e->getMessage());
            }
        }
    }
}
