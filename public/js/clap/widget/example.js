define('widget/example', ['util/Base'], function (widgetBase) {

	return new Class({
		
		Extends: widgetBase,
		Binds: [],

		postMixinProperties: function () {
			this.setup()
		},

		setup: function () {
			console.log('example')
		}
	})
})