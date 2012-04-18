define('widget/register', ['util/Base'], function (widgetBase) {
	return new Class({
		Extends: widgetBase,
		Binds: [],

		postMixinProperties: function () {
			this.setup();
		},

		setup: function () {
			this.src.addEvents({

			});
		}
	});
});