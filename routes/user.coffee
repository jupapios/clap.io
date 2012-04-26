haibu = require("../../haibu/lib/haibu")
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

exports.create_app = (req, res) ->
	if req.session.user and req.body.app_name and req.body.git and req.body.domain and req.body.start
			user = req.session.user.user
			app_name = user+"_"+req.body.app_name
			git = req.body.git
			domain = req.body.domain+".clap.io"
			start = req.body.start

			# Create a new client for communicating with the haibu server
			client = new haibu.drone.Client
				host: process.env.HOST || '127.0.0.1'
				port: 9002

			# A basic package.json for a node.js application on Haibu
			app_json =
				user: user
				name: app_name
				domain: domain
				repository:
					type: "git"
					url: git

				scripts:
					start: start

				engine:
					node: "0.6.14"

			# Attempt to start up a new application
			client.start app_json, (err, result) ->
				if err
					res.json({err: err})
				else
					# update proxy with domain and result.drone.port
					#console.log user, app_name, git, domain
					#console.log result.drone.port
					GLOBAL.server.proxy.addHost(domain, 'localhost:'+result.drone.port)
					res.json({msg: result})

	else
		res.json({msg: 'security error'})

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
		#req.session.user.apps.push
		#	name: req.body.appname
		#	state: true
		#	domain: req.body.appdomain
		#update_db(req, res)
		res.render "user",
			title: "clap.io - new app"


	else
		res.json({err: 'security error'})

exports.modify_app = (req, res) ->
	if req.session.user
		id = req.params.id || 0
		req.session.user.apps[id].domain = req.body.appdomain
		update_db(req, res)
	else
		res.json({err: 'security error'})

exports.apps = (req, res) ->
	if req.session.user
		if req.params.id
			res.render "user",
				title: "clap.io - user"
				data: req.session.user
				locals:
					id: req.params.id
		else
			res.render "user",
				title: "clap.io - user"
				data: req.session.user
	else
		res.redirect "/login"


exports.logout = (req, res) ->
	req.session.destroy ->
		res.redirect "/login"