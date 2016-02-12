/**
 * Admin
 *
 * @author Thiago Paes <mrprompt@gmail.com>
 **/
$(document).ready(function() {
    if ($('#admin-empresas-index')[0]) {

    }

    if ($('#admin-empresas-editar')[0]) {
	$('#int_telefone').mask('(99) 9999-9999');
	$('#int_cep').mask('99999-999');
	$('#int_cnpj').mask("99.999.999/9999-99");

	// validação
	$('#frmEmpresa').validate({
        debug: true,
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
            str_email: {
                required: true,
                email: true
            },
            str_email_confirma: {
                required:true,
                email:true,
                equalTo: '#str_email'
            },
            str_senha: {
                required: true,
                minlength: 4
            },
            str_senha_confirma: {
                required:true,
                minlength: 4,
                equalTo: '#str_senha'
            },
            int_telefone: {
                required: true,
                minlength: 8
            },
            int_cnpj: {
                required: true,
                minlength: 11
            },
            int_cep: {
                required: true,
                minlength: 8
            },
            str_logradouro: {
                required: true,
                minlength: 4
            }
        },
        messages: {
	    str_nome: {
                required: 'Nome é obrigatório.',
                minlength: 'Nome muito curto.'
            },
            str_email: {
                required: 'E-mail de contato é obrigatório.',
                email: 'E-mail inválido.'
            },
            str_email_confirma: {
                required: 'Confirme seu e-mail.',
                email: 'E-mail de confirmação inválido.',
                equalTo: 'E-mail de confirmação e E-mail de contato são diferentes.'
            },
            str_senha: {
                required: 'Informe uma senha.',
                minlength: 'Senha muito curta.'
            },
            str_senha_confirma: {
                required: 'Digite novamente sua senha.',
                minlength: 'Senha de confirmação muito curta.',
                equalTo: 'Senhas não conferem.'
            },
            int_telefone: {
                required: 'Telefone é obrigatório.',
                minlength: 'Telefone inválido.'
            },
            int_cnpj: {
                required: 'CNPJ é obrigatório.',
                minlength: 'CNPJ inválido.'
            },
            int_cep: {
                required: 'CEP é obrigatório.',
                minlength: 'CEP inválido.'
            },
            str_logradouro: {
                required: 'Informe seu logradouro.',
                minlength: 'Logradouro muito curto.'
            }
        }
    });

    // busca de CEP
    $('#int_cep').bind('blur', function() {
        $.getScript("http://cep.republicavirtual.com.br/web_cep.php?formato=javascript&cep=" + $("#int_cep").val().replace('-', ''), function() {
            if (resultadoCEP["resultado"]) {
                // troca o valor dos elementos
                $("#str_logradouro").val(unescape(resultadoCEP["tipo_logradouro"]) + " " + unescape(resultadoCEP["logradouro"]));
                $('#str_complemento').focus();
            } else {
                alert("Endereço não encontrado");
            }
        });
    });
    }
});