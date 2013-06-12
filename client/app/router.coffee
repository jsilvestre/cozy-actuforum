ArticleCollection = require '../collections/articles'
AppView = require 'views/app_view'

module.exports = class Router extends Backbone.Router

    routes:
        '': 'main'

    main: ->
        mainView = new AppView collection: new ArticleCollection()
        mainView.render()