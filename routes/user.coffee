crypto = require("crypto")

authenticate = (name, pass, fn) ->
	user = users[name]
	return fn(new Error('cannot find user')) unless user
	return fn(null, user) if user.pass == hash(pass, user.salt)
	return fn(new Error('invalid password'))

hash = (msg, key) ->
	crypto.createHmac("sha256", key).update(msg).digest "hex"

users = 
	demo:
		name: "Usuario de prueba"
		salt: "randomly-generated-salt"
		pass: hash("demo", "randomly-generated-salt")

exports.index = (req, res) ->
	if req.session.user
		if req.xhr
			res.render "user/profile",
				layout: false
				title: "clap.io - User"
		else
			res.render "user/profile",
				title: "clap.io - User"
	else
		res.render "user",
			title: "clap.io - User"
			msg: false

exports.login = (req, res) ->
	authenticate req.body.username, req.body.password, (err, user) ->
		if user
			req.session.regenerate ->
				req.session.user = user
				res.redirect "/user"
		else
			res.render "user",
				title: "clap.io - User"
				layout: false
				msg: true

exports.logout = (req, res) ->
	req.session.destroy ->
		res.redirect "/user"