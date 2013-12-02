http = require 'http'
express = require 'express'
init = require './server/init'
configure = require './server/config'
router = require './server/router'
RssManager = require './server/rss_manager'

module.exports = app = express()

app.init = ->
    configure(app)
    app.set 'views', __dirname + '/client'
    app.engine '.html', require('jade').__express
    # static middleware
    app.use express.static __dirname + '/client/public',
        maxAge: 86400000
    router(app)
    return app

app.startRssManager = ->
    url = "http://www.enov.fr/mesinfos/index.php?option=com_kunena&view=topics&format=feed&layout=default&mode=topics&sel=720&type=rss&Itemid=149"

    refreshRate = @get 'refreshTime' # see config.coffee
    rssManager = new RssManager url, refreshRate, @
    rssManager.initialize()

if not module.parent

    init ->
        app.init()
        port = process.env.PORT or 9255
        host = process.env.HOST or "127.0.0.1"

        server = http.createServer(app).listen port, host, ->
            console.log "Server listening on %s:%d within %s environment",
                host, port, app.get('env')

            app.startRssManager()