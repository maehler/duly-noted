{CompositeDisposable} = require 'atom'
{$, View} = require 'atom-space-pen-views'
Directory = require './directory'
File = require './file'
DirectoryView = require './directory-view'
FileView = require './file-view'

module.exports =
  class NotebookView extends View
    panel: null

    initialize: (state) ->
      @root = @populate()

      @handleEvents()

    @content: ->
      @div =>
        @div class: 'notebook-view', =>
          @ol tabindex: -1, outlet: 'list',
        @div class: 'note-view', =>
          @ol class: 'note-list', outlet: 'noteList'

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

    handleEvents: ->
      @on 'click', '.entry', (e) =>
        return if e.target.classList.contains('entries')
        @entryClicked(e)

    entryClicked: (e) ->
      entry = e.currentTarget
      isRecursive = e.altKey or false
      if entry instanceof DirectoryView
        @selectEntry(entry)
        entry.toggleExpansion(isRecursive)

      false

    selectEntry: (entry) ->
      entry.classList.add('selected')
      @noteList[0].innerHTML = ''
      for name, file of entry.directory.entries when file instanceof File
        fileView = new FileView()
        fileView.initialize(file)
        @noteList[0].appendChild(fileView)

    serialize: ->
      showing: @panel.isVisible()

    show: ->
      if @panel?
        @panel.show()
      else
        @panel = atom.workspace.addRightPanel(item: @)

    hide: ->
      @panel.hide() unless !@panel?
