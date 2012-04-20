require(['util/Parser'], function (Parser) {
	new Parser().parse()
	document.body.removeChild(document.getElementById('loader'))
})