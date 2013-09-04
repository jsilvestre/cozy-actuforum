News = require '../models/news'
module.exports =

    list: (req, res) ->
        News.getOrderByDate (err, news) ->
            return res.error 500, "Listing failed.", err if err?

            res.render 'index.jade', newsList: news, (err, html) ->
                console.log err if err?
                res.send 200, html