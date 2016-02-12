<?php
class Admin_Form_Empresa extends Zend_Form
{
    protected $_empresa = null;

    public function init()
    {
        $this->_empresa = Zend_Controller_Front::getInstance()
                                               ->getRequest()
                                               ->getParam('empresa', null);

        $this->setAction('?');
        $this->setName('frmEmpresa');
        $this->setAttrib('class', 'well form-empresa');
        $this->setDecorators(array('FormElements', 'Form'));

        $this->addElement('text', 'str_nome', array(
            'label'       => 'Nome da Empresa',
            'required'    => true,
            'filters'     => array('StringTrim'),
            'validators'  => array('NotEmpty'),
            'decorators'  => array(
                'ViewHelper',
                'Errors',
                array(
                    'Label',
                    array('separator' => ' ')
                ),
                array(
                    array('data' => 'HtmlTag'),
                    array('tag' => 'div', 'class' => 'span2')
                )
            ),
            'placeholder' => 'Nome da empresa',
            'class'       => 'input-xxlarge'
        ));
        $this->addDisplayGroup(array('str_nome'), 'grupo0');

        $this->addElement('text', 'str_email', array(
            'label'      => 'Email',
            'required'   => true,
            'filters'    => array('StringTrim'),
            'validators' => array('EmailAddress'),
            'decorators' => array(
                'ViewHelper',
                'Errors',
                array(
                    'Label',
                    array('separator' => ' ')
                ),
                array(
                    array('data' => 'HtmlTag'),
                    array('tag' => 'div', 'class' => 'span2 offset0')
                )
            ),
            'placeholder' => 'E-mail de contato',
            'class'       => 'input-large'
        ));

        $this->addElement('text', 'int_telefone', array(
            'label'      => 'Telefone',
            'required'   => true,
            'filters'    => array('StringTrim'),
            'validators' => array('NotEmpty'),
            'decorators' => array(
                'ViewHelper',
                'Errors',
                array(
                    'Label',
                    array('separator' => ' ')
                ),
                array(
                    array('data' => 'HtmlTag'),
                    array('tag' => 'div', 'class' => 'span2 offset2')
                )
            ),
            'placeholder' => 'Telefone de contato',
            'class'       => 'input-large'
        ));

        $this->addDisplayGroup(array('str_email', 'int_telefone'), 'grupo1');

        if ($this->_empresa == null) {
            $this->addElement('password', 'str_senha', array(
                'label'      => 'Senha',
                'required'   => true,
                'filters'    => array('StringTrim'),
                'validators' => array('NotEmpty'),
                'decorators' => array(
                    'ViewHelper',
                    'Errors',
                    array(
                        'Label',
                        array('separator' => ' ')
                    ),
                    array(
                        array('data' => 'HtmlTag'),
                        array('tag' => 'div', 'class' => 'span2 offset0')
                    )
                ),
                'placeholder' => 'Senha de acesso',
                'class'       => 'input-large'
            ));

            $this->addElement('password', 'str_senha_confirma', array(
                'label'      => 'Repita sua senha',
                'required'   => true,
                'filters'    => array('StringTrim'),
                'validators' => array('NotEmpty'),
                'decorators' => array(
                    'ViewHelper',
                    'Errors',
                    array(
                        'Label',
                        array('separator' => ' ')
                    ),
                    array(
                        array('data' => 'HtmlTag'),
                        array('tag' => 'div', 'class' => 'span2 offset2')
                    )
                ),
                'placeholder' => 'Repita a senha',
                'class'       => 'input-large'
            ));
            $this->addDisplayGroup(array('str_senha', 'str_senha_confirma'), 'grupo_senhas');
        }

        $this->addElement('text', 'int_cep', array(
            'label'      => 'CEP',
            'required'   => true,
            'filters'    => array('StringTrim'),
            'validators' => array('NotEmpty'),
            'decorators' => array(
                'ViewHelper',
                'Errors',
                array(
                    'Label',
                    array('separator' => ' ')
                ),
                array(
                    array('data' => 'HtmlTag'),
                    array('tag' => 'div', 'class' => 'span2 offset0')
                )
            ),
            'placeholder' => '',
            'class'       => 'input-small'
        ));

        $this->addElement('hidden', 'int_status', array(
            'value'      => '1',
            'decorators' => array('ViewHelper')
        ));
        $this->addDisplayGroup(array('int_cep', 'int_status'), 'grupo5');

        $this->addElement('submit', 'salvar', array(
            'label'      => 'Salvar',
            'ignore'     => true,
            'decorators' => array('ViewHelper'),
            'class'      => 'btn btn-primary offset0'
        ));

        $grupos = $this->getDisplayGroups();

        foreach ($grupos as $grupo) {
            $grupo->setDecorators(array(
                'FormElements',
                array(
                    'HtmlTag',
                    array('tag' => 'div', 'class' => 'row')
                )
            ));
        }
    }
}
