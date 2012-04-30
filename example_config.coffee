exports.cfg =

	cluster:
		master: '127.0.0.1'
		nodes: [
			'192.168.1.27'
		]
	
	mail:
		smtp: "smtp.example.com"
		username: "coupon@example.com"
		password: "yourpassword"
		subject: "Coupon from example.com"
		template: __dirname + '/template/mail.html'