/**
 * Admin
 *
 * @author Thiago Paes <mrprompt@gmail.com>
 **/
$(document).ready(function() {
    // escondo a box de mensagem de erro após x segundos
    setInterval(function() {
	if ($('#messages')[0]) {
	    $('#messages').slideUp('slow', function() {
		//
		});
	}
    }, 3000);
});