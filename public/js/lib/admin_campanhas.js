/**
 * Admin
 *
 * @author Thiago Paes <mrprompt@gmail.com>
 **/
var Campanha = {
    salvar: function() {
	var configConteudo = {
	    extraPlugins : 'autogrow',
	    autoGrow_maxHeight : 800,
	    autoGrow_minHeight: 450,
	    removePlugins : 'resize',
	    toolbarStartupExpanded : true,
	    toolbarCanCollapse : false
	};
	$('#str_conteudo').ckeditor(configConteudo);

        $('#dat_inicio').mask('99/99/9999');
        $('#dat_fim').mask('99/99/9999');

	// validação
	$('#frmCampanha').validate({
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
		str_titulo: {
		    required: true,
		    minlength: 4
		},
		str_conteudo: {
		    required: true,
		    minlength: 4
		},
                id_template: {
                    required: true
                }
	    },
	    messages: {
		str_titulo: {
		    required: 'Título é obrigatório.',
		    minlength: 'Título muito curto.'
		},
		str_conteudo: {
		    required: 'Conteúdo é obrigatório.',
		    minlength: 'Conteúdo muito curto.'
		},
                id_template: {
                    required: 'Selecione o template para a campanha.'
                }
	    }
	});
    },

    emailsAdicionarSelecionados: function() {
        $.post(window.location.href, $('#admin-campanhas-emails form').serialize(), function(response) {
            $('<div/>').attr('id', 'modal').addClass('modal')
                .append($('<div/>').addClass('modal-header')
                        .append($('<button/>').addClass('close').attr('data-dismiss', 'modal'))
                            .append($('<h3/>').text('Pronto')))
                .append($('<div/>').addClass('modal-body')
                        .append($('<p/>').text('E-mails inseridos.')))
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
    },

    gruposAdicionarSelecionados: function() {
        $.post(window.location.href, $('#admin-campanhas-grupos form').serialize(), function(response) {
            $('<div/>').attr('id', 'modal').addClass('modal')
                .append($('<div/>').addClass('modal-header')
                        .append($('<button/>').addClass('close').attr('data-dismiss', 'modal'))
                            .append($('<h3/>').text('Pronto')))
                .append($('<div/>').addClass('modal-body')
                        .append($('<p/>').text('Os e-mails do(s) grupo(s) foram inseridos na campanha.')))
                .append($('<div/>').addClass('modal-footer')
                        .append($('<a/>')
                            .attr('href', '#')
                            .addClass('btn btn-primary')
                            .attr('data-dismiss', 'modal')
                            .text('OK').click(function() {
                                $(":checkbox").attr('checked', false);

                                $('#modal').modal('hide');
                            }))
                ).modal('show');
        });
    }
};

$(document).ready(function() {
    if ($('#admin-campanhas-index')[0]) {
        $('a[data-toggle="modal"]').click(function() {
            $.get($(this).attr('href'), {}, function(retorno) {
                $('.modal-body').html(retorno);
            });
        });
    }

    if ($('#admin-campanhas-criar')[0]) {
        Campanha.salvar();
    }

    if ($('#admin-campanhas-emails')[0]) {
	$('#btnAdicionarSelecionados').click(function() {
            Campanha.emailsAdicionarSelecionados();
	});

	$("#btnSelecionar").click(function() {
	    $(":checkbox").attr('checked', $(":checkbox").attr('checked') !== 'checked' ? true : false);
	});
    }

    if ($('#admin-campanhas-grupos')[0]) {
	$('#btnAdicionarSelecionados').click(function() {
            $('<div/>').attr('id', 'modal').addClass('modal')
                .append($('<div/>').addClass('modal-header')
                        .append($('<button/>').addClass('close').attr('data-dismiss', 'modal'))
                            .append($('<h3/>').text('Vincular grupos')))
                .append($('<div/>').addClass('modal-body')
                        .append($('<p/>').text('Você está prestes a vincular os e-mails dos grupos a campanha, esta operação pode demorar um pouco, não feche a janela até que o aviso de conclusão apareça.'))
                        .append($('<p/>').attr('id', 'msg')))
                .append($('<div/>').addClass('modal-footer')
                        .append($('<a/>')
                            .attr('href', '#')
                            .addClass('btn btn-cancel')
                            .attr('data-dismiss', 'modal')
                            .text('Cancelar').click(function() {
                                $('#modal').modal('hide');
                            }))
                        .append($('<a/>')
                            .attr('href', '#')
                            .addClass('btn btn-primary')
                            .text('OK').click(function() {
                                $('p#msg').css('fontWeight', 'bold').text('Vinculando, aguarde...');
                                
                                Campanha.gruposAdicionarSelecionados();
                            }))
                ).modal('show');
	});

	$("#btnSelecionar").click(function() {
	    $(":checkbox").attr('checked', $(":checkbox").attr('checked') !== 'checked' ? true : false);
	});
    }
});