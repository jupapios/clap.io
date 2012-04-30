exports.cfg =

	cluster:
		master: '127.0.0.1'
		nodes: [
			'192.168.1.27'
		]

	port:
		proxy : 80
		haibu: 4000
		clap: 3000
		mongo: 27017

	mail:
		smtp: "smtp.example.com"
		username: "coupon@example.com"
		password: "yourpassword"
		subject: "Coupon from example.com"
		template: __dirname + '/template/mail.jade'