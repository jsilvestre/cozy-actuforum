db = require '../db/cozy-adapter'

module.exports = News = db.define 'News',
    title        : String
    description  : String
    date         : Date
    pubDate      : Date
    link         : String
    streamSource : String

News.getByStream = (stream, callback) ->
    News.request 'newsbystream', key: stream, callback

News.getOrderByDate = (callback) ->
    News.request 'newsorderbydate', descending: true, callback



