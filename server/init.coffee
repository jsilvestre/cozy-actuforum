async = require 'async'
News = require './models/News'

# MapReduce's map to fetch news for a specific RSS stream
newsByStream = (news) -> emit news.streamSource, news

# MapReduce's map to fetch news ordered by Date
newsByDate = (news) -> emit news.pubDate, news

# Create all requests
module.exports = init = (done = ->) ->
    async.parallel [
        (cb) -> News.defineRequest 'newsbystream', newsByStream, cb
        (cb) -> News.defineRequest 'newsorderbydate', newsByDate, cb
    ], (err) ->
        if err
            console.log "Something went wrong"
            console.log err
            console.log '-----'
            console.log err.stack
        else
            console.log "Requests have been created"

        done(err)

# so we can do "coffee init"
init() if not module.parent