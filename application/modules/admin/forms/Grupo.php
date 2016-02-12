<?php
/**
 * Formulário para criação/edição de grupos de e-mail
 *
 * @author      Thiago Paes <mrprompt@gmail.com>
 */
class Admin_Form_Grupo extends Zend_Form
{
    public function init()
    {
        $this->setAction('?');
        $this->setName('frmGrupo');
        $this->setAttrib('class', 'well span6 form-grupo');

        $this->addElement('text', 'str_nome', array(
            'label'      => 'Nome do Grupo',
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
                    array('tag' => 'div', 'class' => 'span6')
                )
            ),
            'placeholder' => 'Nome do grupo',
            'class'       => 'input-xxlarge'
        ));

        $this->addDisplayGroup(array('str_nome'), 'grupo_identificacao');

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

        $submit = new Zend_Form_Element_Submit('salvar');
        $submit->setValue('Salvar')
               ->setAttrib('class', 'btn btn-primary');
        $this->addElement($submit);
    }
}
