/**
 *	form view
 * 	date: 15/04/2012
 *	author: Juan Pablo Pinilla
 *	modified: 19/04/2012
 */

define('app/form/view', function () {

	return new Class({

		Implements: [Options],

		options: {
			dom: {}
		},

		presenter: null,

		initialize: function (presenter) {

			this.presenter = presenter
			this._dom()
			this._events()

		},

		get: function () {
			var arr = {}

			for(var key in this.options.dom) {
				var item = this.options.dom[key]
				arr[key] = {}
				arr[key].type = item.get('type')
				arr[key].value = item.get('value')
			}

			console.log(arr)
			return arr
		},

		update: function (model) {

			for(var key in model) {
				var el = model[key]
				if (!el.valid) this.options.dom[key].addClass('error')
				else this.options.dom[key].removeClass('error')
			}
		},

		_dom: function () {

			var src = this.presenter.src

			this.options.dom.form = src

			// returns all input elements execpt the submit button
			var inputs = src.getElements('input').filter(function (item, index) {
				return item.get('type') !== 'submit'
			})

			inputs.each(function (item) {
				this.options.dom['input_'+item.get('name')] = item
			}.bind(this))

		},

		_events: function () {

			console.log(this.options.dom.form)
			this.options.dom.form.addEvent('submit', function (event) {
				event.stop()
				console.log('hola')
				return this.presenter.send()
			}.bind(this))
			console.log(2)

			for(var key in this.options.dom) {
				var item = this.options.dom[key]
				item.addEvent('keyup', function () {
					this.presenter.change()
				}.bind(this))
			}

		},

		_response: function (data) {
			console.log(data)
		}

	})

})