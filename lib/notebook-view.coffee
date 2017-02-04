{CompositeDisposable} = require 'atom'
{$, View} = require 'atom-space-pen-views'
Directory = require './directory'
DirectoryView = require './directory-view'

module.exports =
  class NotebookView extends View
    panel: null

    initialize: (state) ->
      @root = @populate()

    @content: ->
      @div =>
        @ol tabindex: -1, outlet: 'list'

    populate: ->
      directory = new Directory(
        name = 'Notebooks',
        path = atom.config.get('duly-noted.noteLocation'),
        isExpanded = true
      )
      root = new DirectoryView()
      root.initialize(directory)
      @list[0].appendChild(root)
      root

    serialize: ->
      showing: @panel.isVisible()

    show: ->
      if @panel?
        @panel.show()
      else
        @panel = atom.workspace.addRightPanel(item: @)

    hide: ->
      @panel.hide() unless !@panel?
