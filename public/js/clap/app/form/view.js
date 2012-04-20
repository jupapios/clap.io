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

		src: null,

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
				arr[key].required = item.get('required') ? true: false
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

			this.src = this.presenter.src

			// returns all input elements except the submit button
			var inputs = this.src.getElements('input').filter(function (item, index) {
				return item.get('type') !== 'submit'
			})

			inputs.each(function (item) {
				this.options.dom['input_'+item.get('name')] = item
			}.bind(this))

		},

		_events: function () {

			this.src.getElements('[type="submit"]').addEvent('click', function (event) {
				return this.presenter.send()
			}.bind(this))

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