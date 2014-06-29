express = require 'express'
port = process.env.BENTEN_CHART_PORT || 3000
app = express()
app.use express.static("#{__dirname}/public")
app.listen port
