{CompositeDisposable} = require 'atom'
{$, View} = require 'atom-space-pen-views'

module.exports =
  class NotebookView extends View
    panel: null

    @content: ->
      @div =>
        @h1 'Duly noted'

    show: ->
      if !@panel?
        @panel = atom.workspace.addRightPanel(item: @)
      else
        @panel.show()

    hide: ->
      @panel.hide() unless !@panel?

    test: ->
      console.log 'this is a test'
