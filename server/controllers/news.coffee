News = require '../models/news'
module.exports =

    list: (req, res) ->
        console.log "list request"
        News.getOrderByDate (err, news) ->
            return res.error 500, "Listing failed.", err if err?

            res.send news, 200