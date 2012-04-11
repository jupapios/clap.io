
$("#login").submit ->
	fields = $("#login").find('input:text,input:password')
	$.each fields, (key, item) ->
		if $(item).val() == ''
			$(item).addClass 'error'
		else
			$(item).removeClass 'error'
	if $("#login").find('input.error').length == 0
		$.post "/user",
			username: $("#login").find('input:text').val()
			password: $("#login").find('input:password').val()
		, (data) ->
			$("body").hide "slow", ->
				$('body').html data
				$('body').show "slow"
	return false