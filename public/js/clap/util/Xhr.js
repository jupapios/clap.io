define('util/Xhr', function () {
	return new Class({

		_req: null,
		_data: null,

		initialize: function () {},

		send: function (url, args) {
			successRequest = false;
			_req = new Request({
				url: url,
				onRequest: function(){
					// define using .onRequest()
				},
				onSuccess: function (data) {
					this._data = data;
					successRequest = true;
				},
				onFailure: function () {
					successRequest = true;
				}
			}).post(args);

			var interval = setInterval(function() {
				if (successRequest) {
					clearInterval(interval);
					bar();
				}
			}, 100);
			return this.data;
		}

	});
});	