db = require '../db/cozy-adapter'
async = require 'async'

module.exports = News = db.define 'News',
    title        : String
    description  : String
    date         : Date
    pubDate      : Date
    link         : String
    streamSource : String
    id: String

News.getByStream = (stream, callback) ->
    News.request 'newsbystream', key: stream, callback

News.getOrderByDate = (callback) ->
    News.request 'newsorderbydate', descending: true, callback

News.alreadyExist = (news, callback) ->
    key = news.title
    News.request 'allLike', key: key, (err, allNews) ->
        if err? or not allNews?
            console.log "An error occurred -- #{err}"
            callback false
        else
            alreadyExist = allNews.length >= 1
            callback alreadyExist

News.deduplicate = (callback) ->

    console.log "Deduplicating news...(patch)"
    News.request 'all', (err, news) ->
        process = (news, callback) ->
            News.request 'allLike', key: news.title, (err, allNews) ->
                processRemove = (news, callback) ->
                    news.destroy callback

                allNews.pop()
                if allNews.length > 0
                    console.log "Removing #{allNews.length} duplicated news..."
                async.eachSeries allNews, processRemove, callback

        async.eachSeries news, process, (err) ->
            callback err