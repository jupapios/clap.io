listen =
	appclick: (element) ->
		id = $(element).get('data-app')
		try
			$$('.apps').getElement('.block').removeClass('block')
		catch error
		$$('.app-'+id).addClass('block')
		history.pushState('', '', id);
	newapp: () ->
		try
			$$('.apps').getElement('.block').removeClass('block')
		catch error
		$$('.new_app').addClass('block')
		history.pushState('', '', 'new');

attach = -> 
	$$("#login").addEvent "submit", (event) ->
		event.stop()
		fields = $("login").getElements("input[type=text],input[type=password]")

		Array.each fields, (item, index) ->
			if item.get("value") == ""
				item.addClass "error"
			else
				item.removeClass "error"
		if $("login").getElements("input.error").length == 0
			$(document.body).set 'reveal', 
				duration: 'long'
				transition: 'bounce:out'
			request = new Request
				data:
					username: $("login").getElement('input[type=text]').get("value")
					password: $("login").getElement('input[type=password]').get("value")
				onProgress: (event, xhr) ->
					console.log 'loading'
				onSuccess: (data) ->
					el = $(document.body)
					el.dissolve()
					.set('html', data)
					.reveal()
					history.pushState('', '', 'apps/');
			request.send()
		return false
attach()

window.listen = listen