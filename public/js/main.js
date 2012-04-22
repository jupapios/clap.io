require(['util/Parser'], function (Parser) {
	new Parser().parse()

	var scroll = new Fx.SmoothScroll({ duration:700 }, window)

	document.body.removeChild(document.getElementById('loader'))

	// Position fixed fix
	if (navigator.userAgent.match(/iPhone/i) || navigator.userAgent.match(/iPod/i)) {
		scroll.addEvent('scrolledTo', function (evt) {
			document.getElementById('fixed').style.top = window.pageYOffset + 'px'
		})
		window.onscroll = function() {
			document.getElementById('fixed').style.top = window.pageYOffset + 'px'
		}
	}
})