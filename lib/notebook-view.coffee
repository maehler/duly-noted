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
      @div class: 'notebook-view-resizer', =>
        @div class: 'notebook-view', =>
          @ol class: 'notebook-list entries', tabindex: -1, outlet: 'list',
        @div class: 'note-view-toolbar', =>
          @button class: 'add-notebook', title: 'Add notebook', =>
            @i class: 'fa fa-plus right-space'
            @i class: 'fa fa-folder-o left-space'
          @button class: 'add-note', title: 'Add note', =>
            @i class: 'fa fa-plus right-space'
            @i class: 'fa fa-file-text-o left-space'
        @div class: 'note-view', =>
          @ol class: 'note-list', outlet: 'noteList',
        @div class: 'notebook-view-resize-handle'

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
      @on 'click', '.note', (e) => @noteClicked(e)

      @on 'mousedown', '.notebook-view-resize-handle', (e) => @resizeStarted(e)

    resizeStarted: =>
      $(document).on('mousemove', @resizeNoteView)
      $(document).on('mouseup', @resizeStopped)

    resizeStopped: =>
      $(document).off('mousemove', @resizeNoteView)
      $(document).off('mouseup', @resizeStopped)

    resizeNoteView: ({pageX, which}) =>
      return @resizeStopped() unless which is 1
      width = @outerWidth() + @offset().left - pageX
      @width(width)

    entryClicked: (e) ->
      entry = e.currentTarget
      isRecursive = e.altKey or false
      if entry instanceof DirectoryView
        @selectEntry(entry)
        entry.toggleExpansion(isRecursive)

      false

    noteClicked: (e) ->
      note = e.currentTarget
      atom.workspace.open(note.path)

      false

    selectEntry: (entry) ->
      @deselectEntries()
      entry.classList.add('selected')
      @noteList[0].innerHTML = ''
      for name, file of entry.directory.entries when file instanceof File
        fileView = new FileView()
        fileView.initialize(file)
        @noteList[0].appendChild(fileView)

    getSelectedEntries: ->
      @list[0].querySelectorAll('.selected')

    deselectEntries: (entries=@getSelectedEntries()) ->
      selected.classList.remove('selected') for selected in entries

    serialize: ->
      showing: @panel.isVisible()

    show: ->
      if @panel?
        @panel.show()
      else
        @panel = atom.workspace.addRightPanel(item: @)

    hide: ->
      @panel.hide() unless !@panel?
