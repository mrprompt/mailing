<?php
class Admin_Form_Login extends Zend_Form
{
    public function init()
    {
        $this->setAction('/admin/acesso/login');
        $this->setAttrib('class', 'well form-login');

        $email = new Zend_Form_Element_Text('str_email');
        $email->setLabel('E-mail')
              ->setRequired(true)
              ->setValidators(array('EmailAddress'))
              ->setAttrib('class', 'input-large')
              ->setAttrib('placeholder', 'e-mail');

        $senha = new Zend_Form_Element_Password('str_senha');
        $senha->setLabel('Senha')
              ->setRequired(true)
              ->setValidators(array('NotEmpty'))
              ->setAttrib('class', 'input-large')
              ->setAttrib('placeholder', 'senha');

        $submit = new Zend_Form_Element_Submit('Acessar');
        $submit->setValue('Acessar')->setAttrib('class', 'btn btn-primary');

        $this->addElements(array($email, $senha, $submit));
    }
}

