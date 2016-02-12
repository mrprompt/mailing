<?php
class Admin_Form_Email extends Zend_Form
{
    public function init()
    {
        $this->setAction('/admin/emails/salvar');
        $this->setName('frmEmail');
        $this->setAttrib('class', 'well form-email');
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

        $grupo  = new EmailGrupo();
        $grupos = $grupo->lista(Zend_Registry::get('Zend_Session')->empresa->id_empresa);
        $lista  = array();

        foreach ($grupos as $linha) {
            $lista[$linha->id_email_grupo] = $linha->str_nome;
        }

        $this->addElement('select', 'id_email_grupo', array(
            'label'      => 'Grupo',
            'required'   => true,
            'filters'    => array('StringTrim'),
            'validators' => array('NotEmpty'),
            'MultiOptions' => $lista,
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
            'class'       => 'input-large'
        ));
        $this->addDisplayGroup(array('str_email', 'id_email_grupo'), 'grupo_identificacao');
        unset($grupos);

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

        $id = new Zend_Form_Element_Hidden('id_email');

        $this->addElement($id);
    }
}
