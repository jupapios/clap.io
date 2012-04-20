/**
 *	Login View
 * 	date: 15/03/2012
 *	author: Juan Pablo Pinilla
 */

define('app/login/view', function () {

	return new Class({

		Implements: [Options],

		options: {

			selectors: {
				user_input: '[name="username"]',
				pass_input: '[name="password"]',
				form: 'form'
			},

			dom: {},
		},

		presenter: null,

		initialize: function (presenter) {

			this.presenter = presenter;
			this.options.dom.container = presenter.src;
			this._dom();
			this._events();

		},

		get: function () {
			var arr = {
				user_input: {
					type: this.options.dom.user_input.get('type'),
					value: this.options.dom.user_input.get('value')
				},
				pass_input: {
					type: this.options.dom.pass_input.get('type'),
					value: this.options.dom.pass_input.get('value')
				}
			};
			return arr;
		},

		update: function (model) {

			for(var key in model) {
				var el = model[key];
				if (!el.valid) this.options.dom[key].addClass('error');
				else this.options.dom[key].removeClass('error');
			}
		},

		_dom: function () {

			var src = this.options.dom.container;
			this.options.dom.user_input = src.getElement(this.options.selectors.user_input);
			this.options.dom.pass_input = src.getElement(this.options.selectors.pass_input);
			this.options.dom.form = src.getElement(this.options.selectors.form);

		},

		_events: function () {

			this.options.dom.user_input.addEvent('keyup', function () {
				this.presenter.change();
			}.bind(this));

			this.options.dom.pass_input.addEvent('keyup', function () {
				this.presenter.change()
			}.bind(this));

			this.options.dom.form.addEvent('submit', function (event) {
				//event.stop();
				//this._response();
				return this.presenter.send();
			}.bind(this));

		},

		_response: function (data) {
			console.log(data);
		}

	});

});