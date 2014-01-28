async = require 'async'
request = require 'request'
FeedParser = require 'feedparser'
News = require './models/news'
NotificationsHelper = require 'cozy-notifications-helper'

module.exports = class RssManager

    constructor: (@url, @refreshRate, @app) ->
        @articles = {}
        @notifHelper = new NotificationsHelper 'actuforum'

    initialize: ->
        @updateFeed () =>
            setInterval(() =>
                @updateFeed()
            , @refreshRate)

    updateFeed: (callback) ->
        console.log "=> Updating the feed..."
        that = @
        options =
            url: @url
            timeout: 15000
        request(options, (error, res, body) ->
            if error?
                console.log "Request to data source has failed -- #{error}"
                callback() if callback?
        )
        .pipe(new FeedParser())
        .on('error', (error) ->
            console.log "**** ERROR ****"
            console.log error
        )
        .on('readable', ->
            stream = this
            while item = stream.read()
                article = {}
                article.title = item.title
                article.description = item.description
                article.date = item.date
                article.link = item.link
                article.pubDate = item.pubDate
                article.streamSource = item.link
                that.articles[article.title] = article
        )
        .on('end', =>
            numNewArticles = Object.keys(@articles).length
            console.log "\t# Articles found: #{numNewArticles}."
            @newArticlesCount = 0

            articlesAsArray = []
            articlesAsArray.push article for title, article of @articles

            process = (article, callback) =>
                News.alreadyExist article, (alreadyExist) =>

                    if alreadyExist
                        callback()
                    else
                        News.create article, (err, article) =>
                            if err?
                                msg = "Article creation failed -- #{err}"
                                console.log msg
                            else
                                @newArticlesCount++
                            callback()

            async.eachSeries articlesAsArray, process, (err) =>
                console.log err if err?

                if @newArticlesCount > 0
                    @notifHelper.createTemporary
                        text: "Il y a #{@newArticlesCount} nouvelle(s) actualité(s) MesInfos à consulter."
                        resource: {app: 'actuforum'}

                callback() if callback?
                console.log "\t# New articles added: #{@newArticlesCount}"
                console.log "\t# Feed updated."
        )
