<?php
class Admin_Form_EmailImportacaoArquivo extends Zend_Form
{
    public function init()
    {
        $this->setAction('/admin/emails/upload');
        $this->setName('frmEmailImportar');
        $this->setAttrib('class', 'well span4 form-email-import');
        $this->setAttrib('enctype', 'multipart/form-data');
        $this->setDecorators(array('FormElements', 'Form'));
        $this->removeDecorator('DtDdWrapper');

        $this->files = new Zend_Form_Element_File('arquivos');
        $this->files
             ->setLabel('Arquivo de e-mails')
             ->setMultiFile(4)
//             ->setMaxFileSize(209715200) // 200Mb
             ->addValidator('NotEmpty')
             ->addValidator(new Zend_Validate_File_Size('2MB'))
             ->addValidator('Count', 3)
             ->addValidator('Extension', false, 'csv, txt')
             ->addDecorator('Errors');
        ;

        $this->addElement('submit', 'enviar', array(
            'label'      => 'Enviar',
            'ignore'     => true,
            'decorators' => array('ViewHelper'),
            'class'      => 'btn btn-primary offset1'
        ));
        $this->addDisplayGroup(array('enviar'), 'grupo5');

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
