ViewCollection = require '../lib/view_collection'
Article = require '../models/article'
ArticleView = require './article_view'

module.exports = class AppView extends ViewCollection

    el: 'body.application'
    template: require('./templates/home')
    itemview: ArticleView
    collectionEl: '#article-list'

    events:
        'click #save-config': 'onSubmit'
        'click #action-bot': 'onActionBot'
        'click #set-topic': 'onSetTopic'
        'click #set-mode': 'onSetMode'

    afterRender: ->
        super()
        @collection.fetch()

