{CompositeDisposable} = require 'atom'
{$, View} = require 'atom-space-pen-views'

module.exports =
  class NotebookView extends View
    panel: null

    @content: ->
      @div =>
        @h1 'Duly noted'

    serialize: ->
      showing: @panel.isVisible()

    show: ->
      if @panel?
        @panel.show()
      else
        @panel = atom.workspace.addRightPanel(item: @)

    hide: ->
      @panel.hide() unless !@panel?

    test: ->
      console.log 'this is a test'
