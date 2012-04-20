exports.index = (req, res) ->
  logged = false
  if req.session.user
    logged = true
  res.render "index",
    title: "clap-io - Home"
    logged: logged