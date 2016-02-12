<?php
class Admin_Form_EmailImportacaoLista extends Zend_Form
{
    public function init()
    {
        $this->setAction('/admin/emails/importar');
        $this->setName('frmEmailImportar');
        $this->setAttrib('class', 'well form-email-import');
        $this->setAttrib('enctype', 'multipart/form-data');
        $this->setDecorators(array('FormElements', 'Form'));
        $this->removeDecorator('DtDdWrapper');

        $this->addElement('textarea', 'emails', array(
            'label'       => 'E-mails',
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
                    array('tag' => 'div', 'class' => 'span0')
                )
            ),
            'placeholder' => 'Nome (opcional) e E-mail, separados por vírgula. Um contato por linha.',
            'class'       => 'input-xxlarge',
            'rows'        => 10
        ));
        $this->addDisplayGroup(array('emails'), 'grupo0');

        $this->addElement('submit', 'salvar', array(
            'label'      => 'Salvar',
            'ignore'     => true,
            'decorators' => array('ViewHelper'),
            'class'      => 'btn btn-primary offset6'
        ));
        $this->addDisplayGroup(array('salvar'), 'grupo5');

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
