<?php
/**
 *
 * @author      Thiago Paes <mrprompt@gmail.com>
 */
class Admin_EmailsController extends Zend_Controller_Action
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
     * Index
     *
     * Lista os e-mails cadastrados
     */
    public function indexAction()
    {
        try {
            $email   = new Email();
            $grupo   = new EmailGrupo();

            $this->view->emails = $email->lista(
                    $this->_session->empresa->id_empresa,
                    $this->_getParam('pagina', 0),
                    $this->_getParam('grupo', null)
            );

            $this->view->grupos = $grupo->lista(
                    $this->_session->empresa->id_empresa
            );
        } catch (Exception $e) {
            $mensagem = array('error' => $e->getMessage());
            $this->_helper->flashMessenger($mensagem);
        }
    }

    /**
     * Editar
     *
     */
    public function editarAction()
    {
        $form = new Admin_Form_Email;

        $id = $this->_getParam('id', null);

        if (!is_null($id)) {
            $email  = new Email;
            $linha  = $email->find($id)->current();
            $campos = $linha->toArray();
            $form->populate($campos);
        }

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

        if ($this->_request->isPost()) {
            $layout = Zend_Layout::getMvcInstance();
            $layout->disableLayout();

            $response = new Zend_Controller_Response_Http();
            $response->setHeader('Content-type', 'application/json');

            $form = new Admin_Form_Email;
            $data = $this->_request->getPost();

            if ($form->isValid($data)) {
                try {
                    $email  = new Email;
                    $obj    = new stdClass();

                    $obj->empresa = $this->_session->empresa->id_empresa;
                    $obj->grupo   = $data['id_email_grupo'];

                    if (empty($data['id_email'])) {
                        $obj->email = (!empty($data['str_nome']) ? $data['str_nome'] : $data['str_email']) . ':' . $data['str_email'];

                        $email->insere($obj);
                    } else {
                        $obj->id    = $data['id_email'];
                        $obj->email = $data['str_email'];
                        $obj->nome  = $data['str_nome'];

                        $email->atualiza($obj);
                    }

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

            echo Zend_Json::encode($mensagem);
            exit;
        }
    }

    /**
     * Importar
     *
     * Importação de contatos via lista enviado pelo usuário
     */
    public function importarAction()
    {
        $form = new Admin_Form_EmailImportacaoLista();

        if ($this->_request->isPost()) {
            $data = $this->_request->getPost();

            if ($form->isValid($data)) {
                $data['emails'] = preg_replace('/,/', ':', $data['emails']);
                $emails = array();

                preg_match_all('/(.*)([[:alnum:]]{2,3})(\r|\n)?/', $data['emails'], $emails);

                try {
                    $obj = new stdClass();
                    $obj->empresa  = $this->_session->empresa->id_empresa;
                    $obj->email    = implode('|', $emails[0]);

                    $email = new Email;
                    $email->insere($obj);

                    $mensagem = array('success' => 'Contatos importados com sucesso.');
                    $this->_helper->flashMessenger($mensagem);

                    $this->_redirect('/admin/emails');
                } catch (Exception $e) {
                    $mensagem = array('error' => $e->getMessage());
                    $this->_helper->flashMessenger($mensagem);

                    $this->_redirect('/admin/emails/importar');
                }
            }

            $form->populate($data);
        }

        $this->view->form = $form;
    }

    /**
     * Upload
     *
     * Importação de contatos a partir de um arquivo CSV enviado pelo usuário.
     */
    public function uploadAction()
    {
        $form = new Admin_Form_EmailImportacaoArquivo();

        if ($this->_request->isPost()) {
            $mensagem = array();

            try {
                $data = $this->_request->getPost();

                if ($form->isValid($data)) {
                    $adapter = $form->files->getTransferAdapter();

                    $grupo    = new EmailGrupo;
                    $grupo_id = $grupo->insert(array(
                        'id_empresa' => $this->_session->empresa->id_empresa,
                        'str_nome'   => 'Importação ' . date('Y-m-d H:i:s'),
                        'dat_log'    => date('Y-m-d H:i:s')
                    ));

                    foreach ($adapter->getFileInfo() as $info) {
                        // nome do arquivo de destino na pasta tmp
                        $tmp = 'contatos_'
                             . $this->_session->empresa->id_empresa
                             . '_'
                             . $grupo_id
                             . '_'
                             . uniqid() . '.csv';

                        // salvo o arquivo na pasta tmp e renomeio ele
                        $adapter->addFilter('Rename', array('target'=> APPLICATION_PATH . '/../tmp/'. $tmp, 'overwrite'=>true));

                        if (!$adapter->receive($info['name'])){
                            throw new Exception($adapter->getMessages());
                        }
                    }

                    $mensagem = array('success' => 'Upload efetuado com sucesso, em algun instantes seus contatos estarão disponíveis.');
                }
            } catch (Exception $e) {
                $mensagem = array('error' => $e->getMessage());
            }

            $this->_helper->flashMessenger($mensagem);
            $this->_redirect('/admin/emails/upload');
        }

        $this->view->form = $form;
    }

    /**
     * Apagar
     *
     * Remove um e-mail
     */
    public function apagarAction()
    {
        if ($this->_request->isPost()) {
            $layout = Zend_Layout::getMvcInstance();
            $layout->disableLayout();

            $response = new Zend_Controller_Response_Http();
            $response->setHeader('Content-type', 'application/json');
            
            $data = $this->_request->getPost();

            $email  = new Email;
            $email->apaga($this->_session
                               ->empresa
                               ->id_empresa, implode('|', $data['emails']));

            $mensagem = array('success' => 'E-mails removidos com sucesso.');
            $this->_helper->flashMessenger($mensagem);
        }
    }
}
