module.exports = (app) ->

    news = require './controllers/news'
    app.get '/articles/?', news.list
