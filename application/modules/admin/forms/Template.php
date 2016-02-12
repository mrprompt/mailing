<?php
class Admin_Form_Template extends Zend_Form
{
    protected $_id;

    public function init()
    {
        $this->_id = Zend_Controller_Front::getInstance()
                                               ->getRequest()
                                               ->getParam('id', null);

        $this->setAction('?');
        $this->setName('frmTemplate');
        $this->setAttrib('class', 'well form-template');

        $nome = new Zend_Form_Element_Text('str_nome');
        $nome->setLabel('Nome do template')
             ->setRequired(true)
             ->setValidators(array('NotEmpty'))
             ->setAttrib('class', 'input-xxlarge')
             ->setAttrib('placeholder', 'Nome do Template');

        $titulo = new Zend_Form_Element_Text('str_titulo');
        $titulo->setLabel('Título do e-mail (aceita máscaras)')
               ->setRequired(true)
               ->setValidators(array('NotEmpty'))
               ->setAttrib('class', 'input-xxlarge')
               ->setAttrib('placeholder', 'Título do e-mail');

        $destinos = new Zend_Form_Element_Textarea('str_corpo');
        $destinos->setLabel('Corpo do template (aceita máscaras)')
                 ->setRequired(false)
                 ->setAttrib('class', 'input-xxlarge')
                 ->setAttrib('placeholder', 'Corpo HTML');

        $id = new Zend_Form_Element_Hidden('id_template');
        $id->setValue($this->_id);

        $submit = new Zend_Form_Element_Submit('Salvar');
        $submit->setValue('Salvar')->setAttrib('class', 'btn btn-primary');

        $elementos = array(
            $nome,
            $titulo,
            $destinos,
            $id,
            $submit
        );

        $this->addElements($elementos);
    }
}

