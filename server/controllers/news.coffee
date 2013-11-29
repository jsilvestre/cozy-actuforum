News = require '../models/news'

moment = require 'moment'

module.exports =

    list: (req, res) ->
        News.getOrderByDate (err, newsList) ->
            return res.error 500, "Listing failed.", err if err?

            formatter = "DD/MM/YYYY à HH[h]mm"
            for news in newsList
                formattedDate = moment(news.date).format formatter
                news.formattedDate = formattedDate
                title =  news.title
                news.title = title.substr(0, title.indexOf('- par'))

            res.render 'index.jade', newsList: newsList, (err, html) ->
                console.log err if err?
                res.send 200, html

    widget: (req, res) ->
        News.getOrderByDate (err, newsList) ->
            return res.error 500, "Listing failed.", err if err?

            formatter = "DD/MM/YYYY à HH[h]mm"
            for news in newsList
                formattedDate = moment(news.date).format formatter
                news.formattedDate = formattedDate
                title =  news.title
                news.title = title.substr(0, title.indexOf('- par'))

            res.render 'widget.jade', newsList: newsList, (err, html) ->
                console.log err if err?
                res.send 200, html