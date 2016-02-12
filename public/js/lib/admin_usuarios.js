/**
 * Admin
 *
 * @author Thiago Paes <mrprompt@gmail.com>
 **/
$(document).ready(function() {
    if ($('#admin-usuarios-index')[0]) {
        // apagar e-mails
	$('.btn-danger').click(function() {
	    if ($(":checkbox:checked").length == 0) {
		$('<div/>').attr('id', 'modal').addClass('modal')
		    .append($('<div/>').addClass('modal-header')
			    .append($('<button/>').addClass('close').attr('data-dismiss', 'modal'))
				.append($('<h3/>').text('Erro')))
		    .append($('<div/>').addClass('modal-body')
			    .append($('<p/>').text('Você precisa selecionar pelo menos um usuário')))
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
			.append($('<p/>').text('Remover usuários selecionados?')))
		.append($('<div/>').addClass('modal-footer')
			.append($('<a/>')
			    .attr('href', '#')
			    .addClass('btn btn-danger')
			    .attr('data-dismiss', 'modal')
			    .text('Prosseguir').click(function() {
                                $.post('/admin/usuarios/apagar', $('#admin-usuarios-index form').serialize(), function(response) {
                                    $('<div/>').attr('id', 'modal').addClass('modal')
                                        .append($('<div/>').addClass('modal-header')
                                                .append($('<button/>').addClass('close').attr('data-dismiss', 'modal'))
                                                    .append($('<h3/>').text('Pronto')))
                                        .append($('<div/>').addClass('modal-body')
                                                .append($('<p/>').text('Usuários removidos.')))
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
			    }))
			.append($('<a/>')
			    .attr('href', '#')
			    .addClass('btn btn-primary')
			    .attr('data-dismiss', 'modal')
			    .text('Não, desisto!'))
		).modal('show');
	});

	$('.btn-success').click(function() {
	    $(":checkbox").attr('checked', $(":checkbox").attr('checked') !== 'checked' ? true : false);
	});
    }

    if ($('#admin-usuarios-editar')[0]) {
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
		}
	    }
	});
    }
});