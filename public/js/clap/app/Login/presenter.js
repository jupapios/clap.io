/**
 *	Login Presenter
 * 	date: 15/03/2012
 *	author: Juan Pablo Pinilla
 */

define('app/Login/presenter', ['util/Base', 'app/Login/view', 'app/Login/model'], function (widgetBase, View, Model) {

	return new Class({

		Extends: widgetBase,

		view: null,
		model: null,

		postMixinProperties: function () {
			this.setup();
		},

		setup: function () {
			this.view = new View(this);
			this.model = new Model(this);
		},

		change: function () {
			this.model.update(this.view.get());
			this.view.update(this.model.get());
		},

		send: function () {
			return this.model.send();
		}

	});

});