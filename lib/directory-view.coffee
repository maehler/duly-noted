Directory = require './directory'

class DirectoryView extends HTMLElement
  initialize: (@directory) ->
    @name = @directory.name
    @path = @directory.path

    @entries = document.createElement('ol')

    @directoryName = document.createElement('span')
    @directoryName.dataset.name = @directory.name
    @directoryName.title = @directory.name
    @directoryName.textContent = @directory.name

    @appendChild(@directoryName)
    @appendChild(@entries)

    @expand() if @directory.isExpanded

  expand: ->
    unless @isExpanded?
      @isExpanded = true
      @directory.expand()

      console.log(@directory.entries)

      for name, entry of @directory.entries
        view = @createViewForEntry(entry)
        @entries.appendChild(view) unless !view

  createViewForEntry: (entry) ->
    if entry instanceof Directory
      view = new DirectoryElement()
    else
      return

    view.initialize(entry)

    view

DirectoryElement = document.registerElement('notebook-view-directory', prototype: DirectoryView.prototype, extends: 'li')
module.exports = DirectoryElement
