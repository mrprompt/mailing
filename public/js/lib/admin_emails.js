/**
 * Admin
 *
 * @author Thiago Paes <mrprompt@gmail.com>
 **/
$(document).ready(function() {
    if ($('#admin-emails-index')[0]) {
        // apagar e-mails
	$('.btn-danger').click(function() {
	    if ($(":checkbox:checked").length == 0) {
		$('<div/>').attr('id', 'modal').addClass('modal')
		    .append($('<div/>').addClass('modal-header')
			    .append($('<button/>').addClass('close').attr('data-dismiss', 'modal'))
				.append($('<h3/>').text('Erro')))
		    .append($('<div/>').addClass('modal-body')
			    .append($('<p/>').text('Você precisa selecionar pelo menos um e-mail')))
		    .append($('<div/>').addClass('modal-footer')
			    .append($('<a/>')
				.attr('href', '#')
				.addClass('btn btn-primary')
				.attr('data-dismiss', 'modal')
				.text('OK'))
		    ).modal('show');
		return false;
	    }

	    $('<div/>').attr('id', 'modal').addClass('modal')
		.append($('<div/>').addClass('modal-header')
			.append($('<button/>').addClass('close').attr('data-dismiss', 'modal'))
			    .append($('<h3/>').text('Confirme')))
		.append($('<div/>').addClass('modal-body')
			.append($('<p/>').text('Remover e-mails selecionados?')))
		.append($('<div/>').addClass('modal-footer')
			.append($('<a/>')
			    .attr('href', '#')
			    .addClass('btn btn-danger')
			    .attr('data-dismiss', 'modal')
			    .text('Prosseguir').click(function() {
				$('#admin-emails-index form')
				    .attr('action', '/admin/emails/apagar')
				    .attr('method', 'post')
				    .submit();
			    }))
			.append($('<a/>')
			    .attr('href', '#')
			    .addClass('btn btn-primary')
			    .attr('data-dismiss', 'modal')
			    .text('Não, desisto!'))
		).modal('show');
	});

        // trocar grupo
	$('.btn-info').click(function() {
	    if ($(":checkbox:checked").length == 0) {
		$('<div/>').attr('id', 'modal').addClass('modal')
		    .append($('<div/>').addClass('modal-header')
			    .append($('<button/>').addClass('close').attr('data-dismiss', 'modal'))
				.append($('<h3/>').text('Erro')))
		    .append($('<div/>').addClass('modal-body')
			    .append($('<p/>').text('Você precisa selecionar pelo menos um e-mail')))
		    .append($('<div/>').addClass('modal-footer')
			    .append($('<a/>')
				.attr('href', '#')
				.addClass('btn btn-primary')
				.attr('data-dismiss', 'modal')
				.text('OK'))
		    ).modal('show');
		return false;
	    }

            $.post('/admin/grupos/insereemail', $('#admin-emails-index form').serialize(), function(response) {
		$('<div/>').attr('id', 'modal').addClass('modal')
		    .append($('<div/>').addClass('modal-header')
			    .append($('<button/>').addClass('close').attr('data-dismiss', 'modal'))
				.append($('<h3/>').text('Pronto')))
		    .append($('<div/>').addClass('modal-body')
			    .append($('<p/>').text('Grupo atualizado')))
		    .append($('<div/>').addClass('modal-footer')
			    .append($('<a/>')
				.attr('href', '#')
				.addClass('btn btn-primary')
				.attr('data-dismiss', 'modal')
				.text('OK').click(function() {
                                    $(":checkbox").attr('checked', false);

                                    $('#modal').modal('hide');

                                    window.location.href = window.location.href;
                                }))
		    ).modal('show');
            });

            return true;
	});


	$('.btn-success').click(function() {
	    $(":checkbox").attr('checked', $(":checkbox").attr('checked') !== 'checked' ? true : false);
	});
    }

    if ($('#admin-emails-editar')[0]) {
	// validação
	$('#frmEmail').validate({
	    debug: true,
	    onblur: true,
	    onkeyup: false,
	    onsubmit: true,
	    focusInvalid: true,
	    focusCleanup: false,
	    errorElement: 'span',
	    errorClass: 'errorField',
	    submitHandler: function(form) {
		var $retorno = null

		$.ajax({
		    url: '/admin/emails/salvar',
		    type: 'post',
		    data: $(form).serialize(),
		    dataType: 'json',
		    beforeSend: function() {
			//console.log('enviando...');
		    },
		    error: function() {
			$retorno = 'Erro inesperado';
		    },
		    complete: function() {
			$('<div/>').attr('id', 'modal').addClass('modal')
			.append($('<div/>').addClass('modal-header')
				.append($('<button/>').addClass('close').attr('data-dismiss', 'modal'))
				    .append($('<h3/>').text('Campanha')))
			.append($('<div/>').addClass('modal-body')
				.append($('<p/>').text($retorno)))
			.append($('<div/>').addClass('modal-footer')
				.append($('<a/>').attr('href', '#').addClass('btn btn-primary').attr('data-dismiss', 'modal').text('Fechar'))
			).modal('show');

			setTimeout(function() {
			    $('#modal').modal('hide');
			}, 2000);
		    },
		    success: function(retorno) {
			if (retorno.error) {
			    $retorno = 'Erro: ' + retorno.error;
			}

			if (retorno.success) {
			    $retorno = retorno.success;

			    setTimeout(function() {
				window.location.href = '/admin/emails';
			    }, 2000);
			}
		    },
		    statusCode: {
			404: function() {
			    console.log('pagina não encontrada');
			},
			500: function() {
			    console.log('erro geral');
			}
		    }
		});
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
		    required: true,
		    email: true,
		    equalTo: '#str_email'
		}
	    },
	    messages: {
		str_nome: {
		    required: 'Nome é obrigatório.',
		    minlength: 'Nome muito curto.'
		},
		str_email: {
		    required: 'Preecha o e-mail.',
		    email: 'E-mail inválido.'
		},
		str_email_confirma: {
		    required: 'Confirme seu e-mail.',
		    email: 'E-mail de confirmação inválido.',
		    equalTo: 'E-mail não confere.'
		}
	    }
	});
    }
});