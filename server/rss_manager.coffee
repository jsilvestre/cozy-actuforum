request = require 'request'
FeedParser = require 'feedparser'
News = require './models/news'
NotificationsHelper = require 'cozy-notifications-helper'

module.exports = class RssManager

    constructor: (@url, @refreshRate, @app) ->
        @cachedArticles = {}
        @newArticles = {}
        @notifHelper = new NotificationsHelper 'actuforum'

    initialize: ->
        @fetchFromDatabase () =>
            @updateFeed () =>
                setInterval(() =>
                    @updateFeed()
                , @refreshRate)

    fetchFromDatabase: (callback) ->
        News.getByStream @url, (err, news) =>
            for index, article of news
                @cachedArticles[article.link] = article

            callback() if callback?

    updateFeed: (callback) ->
        console.log "=> Updating the feed..."
        request(@url)
            .pipe(new FeedParser())
            .on('error', (error) ->
                console.log "ERROR"
                console.log error
            )
            .on('article', (article) =>
                if not @cachedArticles[article.link]?
                    @newArticles[article.link] = article
            )
            .on('end', () =>
                numNewArticles = Object.keys(@newArticles).length
                console.log "\t# New articles: #{numNewArticles}."

                for index, article of @newArticles
                    article.streamSource = article.meta.xmlUrl
                    News.create article, (err, article) =>
                        if err
                            console.log "Creation failed."
                        else
                            @cachedArticles[article.link] = article


                @newArticles = []
                if numNewArticles > 0
                    @notifHelper.createTemporary
                        text: "You have #{numNewArticles} unread news from MesInfos."
                        resource: {app: 'actuforum'}

                callback() if callback?

                console.log "\t# Feed updated."
            )
