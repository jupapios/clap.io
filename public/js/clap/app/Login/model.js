/**
 *	Login Presenter
 * 	date: 15/03/2012
 *	author: Juan Pablo Pinilla
 */
define('app/Login/model', ['util/Xhr'],function (Xhr) {
	return new Class({

		valid: false,

		model: {},

		xhr: new Xhr(),

		presenter: null,

		initialize: function (presenter) {

			this.presenter = presenter;
		},

		validate: function () {

			var flag=true;
			var model = this.model;

			for(var key in model) {
				var el = model[key];
				if (el.value == '') {
					el.valid = false;
					this.valid = false;
					flag =false;
				} else {
					el.valid = true;
					if (flag) this.valid = true;
				}
			}

		},

		update: function (model) {

			this.model = model;
			this.validate();

		},

		get: function () {

			return this.model;

		},

		send: function () {
			this.presenter.change();
			if (this.valid) return true;
			return false;

		}

	});
});