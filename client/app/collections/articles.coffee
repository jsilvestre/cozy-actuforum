module.exports = class ArticleCollection extends Backbone.Collection

    model: require '../models/article'
    url: 'articles'
