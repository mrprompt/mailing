/**
 * Admin
 *
 * @author Thiago Paes <mrprompt@gmail.com>
 **/
$(document).ready(function() {
    // listagem de templates
    var configTemplate = {
        extraPlugins : 'autogrow,docprops',
        autoGrow_minHeight: 1600,
        fullPage: true,
        removePlugins : 'resize',
        toolbarStartupExpanded : false,
        toolbarCanCollapse : false
    };

    if ($('#admin-templates-index')[0]) {
	// Initialize the editor.
        configTemplate['readOnly'] = true;

	$('textarea').ckeditor(configTemplate);
    }

    // edição de template
    if ($('#admin-templates-editar')[0]) {
	// Initialize the editor.
        configTemplate.toolbarStartupExpanded = true;
	$('textarea').ckeditor(configTemplate);

	$('#frmTemplate').validate({
	    debug: false,
	    onblur: true,
	    onkeyup: false,
	    onsubmit: true,
	    focusInvalid: false,
	    focusCleanup: true,
	    errorElement: 'span',
	    errorClass: 'errorField',
	    submitHandler: function(form) {
		form.submit();
	    },
	    rules:{
		str_nome: {
		    required: true,
		    minlength: 4
		},
		str_titulo: {
		    required: true,
		    minlength: 4
		}
	    },
	    messages: {
		str_nome: {
		    required: "Informe um nome para o template",
		    minlength: "Nome muito curto"
		},
		str_titulo: {
		    required: "Informe um título para o e-mail do template.",
		    minlength: "Título do e-mail muito curto."
		}
	    }
	});
    }
});