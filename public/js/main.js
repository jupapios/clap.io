require(['util/Parser'], function (Parser) {
	new Parser().parse()

	document.body.removeChild(document.getElementById('loader'))

	// Position fixed fix
	if (navigator.userAgent.match(/iPhone/i) || navigator.userAgent.match(/iPod/i))
		window.onscroll = function() {
			document.getElementById('fixed').style.top = window.pageYOffset + 'px'
		}
})