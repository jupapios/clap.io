exports.cfg =

	cluster:
		master: '127.0.0.1'
		nodes: [
			'192.168.1.27'
		]

	proxy_port: 80
	haibu_port: 4000
	clap_port: 3000
	mongo_port: 27017		

	mail:
		smtp: "smtp.example.com"
		username: "coupon@example.com"
		password: "yourpassword"
		subject: "Coupon from example.com"
		template: __dirname + '/template/mail.html'