http = require 'http'
express = require 'express'
init = require './server/init'
configure = require './server/config'
router = require './server/router'
RssManager = require './server/rss_manager'
realtimeInitializer = require 'cozy-realtime-adapter'

module.exports = app = express()

app.init = ->
    configure(app)
    clientdir = __dirname + '/client/public'
    staticOptions = maxAge: 86400000
    app.use '/public', express.static clientdir, staticOptions
    app.use express.static clientdir, staticOptions
    router(app)
    return app

app.startRssManager = ->
    url = "http://www.enov.fr/communauteados/index.php?option=com_kunena&view=topics&format=feed&layout=default&mode=topics&sel=720&type=rss&Itemid=149"
    refreshRate = 5*1000 #2*3600*1000 # 2h in ms
    rssManager = new RssManager(url, refreshRate, @)
    rssManager.initialize()

if not module.parent

    init ->
        app.init()
        port = process.env.PORT or 9255
        host = process.env.HOST or "127.0.0.1"

        server = http.createServer(app).listen port, host, ->
            console.log "Server listening on %s:%d within %s environment",
                host, port, app.get('env')

            realtimeInitializer server: server, ['news.*']
            app.startRssManager()