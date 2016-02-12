<?php
/**
 *
 * @author      Thiago Paes <mrprompt@gmail.com>
 */
class Api_TemplatesController extends Zend_Controller_Action
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

    /**
     * Início
     *
     * Renderizo para a listagem
     */
    public function indexAction()
    {
        // action body
        $data      = $this->_request->getPost();
        $template  = new Template();
        $templates = $template->lista($this->_session->empresa->id_empresa,
                                      self::LIMITE,
                                      $data['pagina'],
                                      self::PAGINAS);

        echo Zend_Json::encode(array(
            'templates'   => Zend_Json::decode($templates->toJson()),
            'paginacao'   => array(
                'paginas' => $templates->count(),
                'atual'   => $templates->getCurrentPageNumber(),
                'total'   => $templates->getTotalItemCount(),
            )
        ));

        exit;
    }

    /**
     * Salvar
     *
     * Salva os dados de um template
     */
    public function salvarAction()
    {
        try {
            $data = $this->_request->getPost();

            $obj_template = new stdClass();
            $obj_template->id      = (!empty($data['id']) ? $data['id'] : null);
            $obj_template->empresa = $this->_session->empresa->id_empresa;
            $obj_template->titulo  = $data['titulo'];
            $obj_template->nome    = $data['nome'];
            $obj_template->corpo   = $data['corpo'];

            $template = new Template();
            $template->salva($obj_template);

            $mensagem = array('success' => 'Template salvo.');
        } catch (Exception $e) {
            $mensagem = array('error' => $e->getMessage());
        }

        echo Zend_Json::encode($mensagem);
        exit;
    }

    public function apagarAction()
    {
        try {
            $data = $this->_request->getPost();

            $template = new Template;

            $where = array(
                $template->getAdapter()
                         ->quoteInto('id_template = ?', array($data['id'])),
                $template->getAdapter()
                         ->quoteInto('id_empresa = ?', array($this->_session
                                                                  ->empresa
                                                                  ->id_empresa))
            );

            $template->delete($where);

            $mensagem = array('success' => 'Template removido com sucesso.');
        } catch (Exception $e) {
            $mensagem = array('error' => $e->getMessage());
        }

        echo Zend_Json::encode($mensagem);
        exit;
    }
}
