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
		res.redirect "/user/"			

exports.index = (req, res) ->
	if req.session.user
		res.redirect "/user/apps/"
	else
		res.render "user",
			title: "clap.io - User"
			msg: false

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
		if req.xhr
			res.render "user/apps",
				layout: false
				title: "clap.io - User"
				data: req.session.user
		else
			if req.params.id
				res.render "user/apps",
					title: "clap.io - User"
					data: req.session.user
					locals:
						id: req.params.id
			else
				res.render "user/apps",
					title: "clap.io - User"
					data: req.session.user
	else
		res.redirect "/user/"


exports.login = (req, res) ->
	if req.body.username and req.body.password
		authenticate req.body.username, req.body.password, (err, user) ->
			if user
				req.session.regenerate ->
					req.session.user = user
					res.render "user/apps",
						layout: false
						title: "clap.io - User"
						data: req.session.user
			else
				res.render "user",
					title: "clap.io - User"
					layout: false
					msg: true
	else
		res.json({err: 'bad request'})

exports.logout = (req, res) ->
	req.session.destroy ->
		res.redirect "/user/"