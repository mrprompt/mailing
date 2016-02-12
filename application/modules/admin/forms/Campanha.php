<?php
/**
 * Formulário para criação/edição de campanhas
 *
 * @author      Thiago Paes <mrprompt@gmail.com>
 */
class Admin_Form_Campanha extends Zend_Form
{
    public function init()
    {
        $this->setName('frmCampanha');
        $this->setAttrib('class', 'well span6 form-campanha');

        $this->addElement('text', 'str_titulo', array(
            'label'      => 'Nome da campanha',
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
                    array('tag' => 'div', 'class' => 'span3')
                )
            ),
            'placeholder' => 'Nome da campanha',
            'class'       => 'input-large'
        ));

        $template  = new Template;
        $templates = $template->lista(Zend_Registry::get('Zend_Session')->empresa->id_empresa, 100);
        $lista     = array();

        foreach ($templates as $template) {
            $lista[$template->id_template] = $template->str_nome;
        }

        $this->addElement('select', 'id_template', array(
            'label'      => 'Template',
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
                    array('tag' => 'div', 'class' => 'span3')
                )
            ),
            'class'       => 'input-large'
        ));

        $this->addDisplayGroup(array('id_template', 'str_titulo'), 'grupo_identificacao');

        $this->addElement('text', 'dat_inicio', array(
            'label'      => 'Data do início',
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
                    array('tag' => 'div', 'class' => 'span3')
                )
            ),
            'placeholder' => 'dd/mm/aaaa',
            'class'       => 'input-small'
        ));
        $this->addElement('text', 'dat_fim', array(
            'label'      => 'Prazo de envio',
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
                    array('tag' => 'div', 'class' => 'span3')
                )
            ),
            'placeholder' => 'dd/mm/aaaa',
            'class'       => 'input-small'
        ));
        $this->addDisplayGroup(array('dat_inicio', 'dat_fim'), 'grupo_prazo');


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

        $this->addElement('hidden', 'id_campanha');

        $submit = new Zend_Form_Element_Submit('salvar');
        $submit->setValue('Salvar')
               ->setAttrib('class', 'btn btn-primary');
        $this->addElement($submit);
    }
}
