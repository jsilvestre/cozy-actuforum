module.exports = (app) ->

    news = require './controllers/news'
    app.get '/', news.list
    app.get '/widget', news.widget
