<?php
/**
 *
 * @author      Thiago Paes <mrprompt@gmail.com>
 */
class Admin_CampanhasController extends Zend_Controller_Action
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

        $this->_helper->layout->setLayout('admin');
    }

    /**
     * Index
     *
     * Tela inicial (redireciona para a listagem de empresas por enquanto)
     */
    public function indexAction()
    {
        // action body
        try {
            $campanha  = new Campanha;
            $campanha->id_empresa = $this->_session->empresa->id_empresa;
            $campanha->int_pagina = $this->_getParam('pagina', 1);

            $this->view->campanhas = $campanha->lista();
        } catch (Exception $e) {
            $mensagem = array('error' => 'Ocorreu um erro recupernado a lista de campanhas.');

            $this->_helper->flashMessenger($mensagem);
        }
    }

    /**
     * Editar
     *
     * Edita uma campanha
     */
    public function editarAction()
    {
        $form = new Admin_Form_Campanha();

        if ($this->_getParam('campanha')) {
            $campanha = new Campanha();
            $form->populate($campanha->find($this->_getParam('campanha'))->current()->toArray());
        }

        if ($this->_request->isPost()) {
            $data = $this->_request->getPost();

            if ($form->isValid($data)) {
                try {
                    list($dia_ini, $mes_ini, $ano_ini) = explode('/', $data['dat_inicio']);
                    list($dia_fim, $mes_fim, $ano_fim) = explode('/', $data['dat_fim']);

                    $inicio = "{$ano_ini}-{$mes_ini}-{$dia_ini} 00:00:00";
                    $fim    = "{$ano_fim}-{$mes_fim}-{$dia_fim} 23:59:59";

                    $empresa  = $this->_session->empresa->id_empresa;
                    $campanha = new Campanha();
                    $campanha->id_campanha   = $this->_getParam('campanha');
                    $campanha->id_empresa    = $empresa;
                    $campanha->id_template   = $data['id_template'];
                    $campanha->id_prioridade = 1;
                    $campanha->str_titulo    = $data['str_titulo'];
                    $campanha->dat_inicio    = $inicio;
                    $campanha->dat_fim       = $fim;
                    $campanha->salva();

                    $mensagem = array('success' => 'Sucesso.');

                    $this->_helper->flashMessenger($mensagem);

                    $this->_redirect('/admin/campanhas');
                } catch (Exception $e) {
                    $mensagem = array('error' => 'Erro salvando campanha');
                    echo $e->getMessage();

                    $this->_helper->flashMessenger($mensagem);
                }
            } else {
                $mensagem = array('error', $form->getErrors());

                $this->_helper->flashMessenger($mensagem);
            }
        }

        $this->view->form = $form;
    }

    /**
     * Emails
     *
     * lista os e-mails a serem inseridos em uma campanha
     */
    public function emailsAction()
    {
        try {
            $pagina     = $this->_getParam('pagina', 1);
            $campanha   = $this->_getParam('campanha', null);

            $email   = new Fila();
            $emails  = $email->lista($campanha, $pagina);

            $this->view->emails   = $emails;
            $this->view->campanha = $campanha;
        } catch (Exception $e) {
            $mensagem = array('error' => 'Ocorreu um erro recuperando a lista de e-mails. ' . $e->getMessage());
            $this->_helper->flashMessenger($mensagem);
            $this->_redirect('/admin/campanhas');
        }
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

                $obj             = new stdClass();
                $obj->campanha   = (int) $this->_getParam('campanha');
                $obj->prioridade = 1;
                $obj->emails     = implode('|', $data['emails']);

                $tbCampanha = new Fila;
                $tbCampanha->insere($obj);

                $mensagem = array('success' => 'E-mails inseridos com sucesso.');
            } catch (Exception $e) {
                $mensagem = array('error' => $e->getMessage());
            }

            $this->_helper->flashMessenger($mensagem);
            $this->_redirect('/admin/campanhas/insereemail/campanha/'
                            . $this->_getParam('campanha')
                            . '/pagina/'
                            . $this->_getParam('pagina', 1));
        }

        try {
            $email = new Email();

            $this->view->emails = $email->lista(
                    $this->_session->empresa->id_empresa,
                    $this->_getParam('pagina', 1)
            );

            $this->view->campanha = $this->_getParam('campanha');
        } catch (Exception $e) {
            $mensagem = array('error' => 'Ocorreu um erro recuperando a lista de e-mails.');
            $this->_helper->flashMessenger($mensagem);
        }
    }

    /**
     * Inseregrupo
     *
     * Insere os e-mails de um grupo na campanha
     */
    public function inseregrupoAction()
    {
        if ($this->_request->isPost()) {
            $this->_helper->layout->disableLayout();

            try {
                $data = $this->_request->getPost();

                $obj = new stdClass();
                $obj->campanha   = (int) $this->_getParam('campanha');
                $obj->prioridade = 1;
                $obj->grupos     = implode('|', $data['grupos']);
                $obj->empresa    = $this->_session->empresa->id_empresa;

                $fila  = new Fila;
                $fila->insereGrupo($obj);
            } catch (Exception $e) {
                //$mensagem = array('error' => $e->getMessage());
            }
        }

        try {
            $email = new EmailGrupo();

            $this->view->emails = $email->lista(
                    $this->_session->empresa->id_empresa,
                    $this->_getParam('pagina', 1)
            );

            $this->view->campanha = $this->_getParam('campanha');
        } catch (Exception $e) {
            $mensagem = array('error' => 'Ocorreu um erro recuperando a lista de e-mails.');
            $this->_helper->flashMessenger($mensagem);
        }
    }

    /**
     * Relatorios
     *
     * Relatórios de envio da campanha
     */
    public function relatoriosAction()
    {
        try {
            $this->_helper->layout->disableLayout();

            $campanha = new Campanha;
            $campanha->id_campanha = $this->_getParam('campanha');

            $this->view->status= $campanha->status();
        } catch (Exception $e) {
            $mensagem = array('error' => $e->getMessage());
            $this->_helper->flashMessenger($mensagem);
        }
    }

    /**
     * Apagar campanha
     *
     */
    public function apagarAction()
    {
        try {
            $campanha = new Campanha;
            $campanha->id_empresa  = $this->_session->empresa->id_empresa;
            $campanha->id_campanha = $this->_getParam('campanha');
            $campanha->delete();

            $mensagem = array('success' => 'Campanha removida.');
        } catch (Exception $e) {
            $mensagem = array('error' => $e->getMessage());
        }

        $this->_helper->flashMessenger($mensagem);

        $this->_redirect('/admin/campanhas');
    }
}
