News = require '../models/news'
Entities = require('html-entities').AllHtmlEntities
entities = new Entities()
moment = require 'moment'

module.exports =

    list: (req, res) ->
        News.getOrderByDate (err, newsList) ->
            return res.error 500, "Listing failed.", err if err?

            formatter = "DD/MM/YYYY à HH[h]mm"
            for news in newsList
                formattedDate = moment(news.date).format formatter
                news.formattedDate = formattedDate
                news.title = entities.decode news.title

            res.render 'index.jade', newsList: newsList, (err, html) ->
                console.log err if err?
                res.send 200, html

    widget: (req, res) ->
        News.getOrderByDate (err, newsList) ->
            return res.error 500, "Listing failed.", err if err?

            formatter = "DD/MM/YYYY"
            for news in newsList
                formattedDate = moment(news.date).format formatter
                news.formattedDate = formattedDate
                news.title = entities.decode news.title

            res.render 'widget.jade', newsList: newsList, (err, html) ->
                console.log err if err?
                res.send 200, html