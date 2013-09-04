module.exports = (app) ->

    express = require 'express'

    # all environements
    app.use express.bodyParser
        keepExtensions: true

    #test environement
    app.configure 'test', ->
        app.set 'refreshTime', 5 * 1000 # 5 seconds

    #development environement
    app.configure 'development', ->
        app.use express.logger 'dev'
        app.use express.errorHandler
            dumpExceptions: true
            showStack: true
        app.set 'refreshTime', 5 * 1000 # 5 seconds

    #production environement
    app.configure 'production', ->
        app.use express.logger()
        app.use express.errorHandler
            dumpExceptions: true
            showStack: true
        app.set 'refreshTime', 2*3600*1000 # 2 hours in ms
