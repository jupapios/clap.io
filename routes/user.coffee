crypto = require("crypto")
Db = require('mongodb').Db
Server = require('mongodb').Server


users = {}
db = new Db('clap', new Server("127.0.0.1", 27017, {auto_reconnect: false, poolSize: 4}), {native_parser: false})

authenticate = (name, pass, fn) ->
	db.open (err, db) ->
		if db
			db.createCollection 'users', (err, collection) ->
				collection.find({user:name}).toArray (err, docs) ->
					user = docs[0]
					db.close()
					if typeof user == 'undefined'
						return fn(new Error('cannot find user'))
					if user.pass == hash(pass, user.salt)
						delete user._id
						delete user.pass
						delete user.salt
						return fn(null, user)
					fn(new Error('invalid password'))
		else
			fn(new Error('start db'))

hash = (msg, key) ->
	crypto.createHmac("sha256", key).update(msg).digest "hex"

update_db = (req, res) ->
	db.open (err, db) ->
		db.createCollection 'users', (err, collection) ->
			collection.findAndModify {user: req.session.user.user},  [], {$set:req.session.user}, {new:true, upsert:true}, (err, doc) ->
				#console.log req.session.user
				res.redirect("back")

exports.settings = (req, res) ->
	if req.session.user
		res.json({msg: 'TODO'})
	else
		res.redirect "/login"			

exports.index = (req, res) ->
	if req.session.user
		res.redirect "/apps"
	else
		res.render "login",
			title: "clap.io - user"
			msg: false

exports.coupon = (req, res) ->
	if req.session.user
		res.redirect "/apps"
	else
		res.render "coupon",
			title: "clap.io - coupon"
			msg: false

exports.get_coupon = (req, res) ->
	if req.body.email
		db.open (err, db) ->
			db.createCollection 'coupons', (err, collection) ->
				coupon = crypto.createHash('sha1').update((new Date()).valueOf().toString() + Math.random().toString()).digest('hex');
				collection.insert {email: req.body.email, coupon: coupon, date: new Date()}, (err, doc) ->
					res.render "coupon",
						title: "clap.io - coupon"
						msg: true

	else
		res.json({err: 'bad request'})

exports.register = (req, res) ->
	if req.session.user
		res.redirect "/apps"
	else
		res.render "register",
			title: "clap.io - register"
			msg: false

exports.new_user = (req, res) ->
	if req.body.username and req.body.password and req.body.email and req.body.coupon
		db.open (err, db) ->
			db.createCollection 'coupons', (err, collection) ->
				collection.findOne {'email':req.body.email}, (err, item) ->
					console.log item
					if item.coupon == req.body.coupon
						db.createCollection 'users', (err, collection) ->
							collection.findAndModify {user: req.body.username},  [], {$set:{email:req.body.email, salt:req.body.coupon, pass:hash(req.body.password, req.body.coupon)}}, {new:true, upsert:true}, (err, doc) ->
								console.log doc
					else
						res.json({err: 'invalid coupon'})

	else
		res.json({err: 'bad request'})

exports.login = (req, res) ->
	if req.body.username and req.body.password
		authenticate req.body.username, req.body.password, (err, user) ->
			if user
				req.session.regenerate ->
					req.session.user = user
					res.redirect "/apps"
			else
				res.render "login",
					title: "clap.io - user"
					msg: true
	else
		res.json({err: 'bad request'})

exports.new_app = (req, res) ->
	if req.session.user
		req.session.user.apps.push
			name: req.body.appname
			state: true
			domain: req.body.appdomain
		update_db(req, res)

	else
		res.json({msg: 'security error'})		

exports.modify_app = (req, res) ->
	if req.session.user
		id = req.params.id || 0
		req.session.user.apps[id].domain = req.body.appdomain
		update_db(req, res)
	else
		res.json({msg: 'security error'})

exports.apps = (req, res) ->
	if req.session.user
		if req.params.id
			res.render "user/apps",
				title: "clap.io - user"
				data: req.session.user
				locals:
					id: req.params.id
		else
			res.render "user/apps",
				title: "clap.io - user"
				data: req.session.user
	else
		res.redirect "/user"


exports.logout = (req, res) ->
	req.session.destroy ->
		res.redirect "/login"