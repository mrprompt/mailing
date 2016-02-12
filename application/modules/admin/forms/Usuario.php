<?php
class Admin_Form_Usuario extends Zend_Form
{
    public function init()
    {
        $id = Zend_Controller_Front::getInstance()->getRequest()->getParam('usuario');

        $this->setName('frmEmail');
        $this->setAttrib('class', 'well form-usuario');
        $this->setDecorators(array('FormElements', 'Form'));

        $this->addElement('text', 'str_nome', array(
            'label'       => 'Nome',
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
            'placeholder' => 'Nome completo',
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

        $this->addElement('password', 'str_senha', array(
            'label'      => 'Senha',
            'required'   => (strlen($id) !== 0 ? false : true),
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
            'placeholder' => 'Senha de acesso',
            'class'       => 'input-large'
        ));
        $this->addDisplayGroup(array('str_email', 'str_senha'), 'grupo1');

        $this->addElement('submit', 'salvar', array(
            'label'      => 'Salvar',
            'ignore'     => true,
            'decorators' => array('ViewHelper'),
            'class'      => 'btn btn-primary offset6'
        ));
        $this->addDisplayGroup(array('status', 'limpar', 'salvar'), 'grupo5');

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

        $id = new Zend_Form_Element_Hidden('id_usuario');

        $this->addElement($id);
    }
}
