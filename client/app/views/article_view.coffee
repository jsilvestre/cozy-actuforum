BaseView = require '../lib/base_view'

module.exports = class ArticleView extends BaseView

    tagName: 'div'
    template: require('./templates/article')