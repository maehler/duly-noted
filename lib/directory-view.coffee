Directory = require './directory'

class DirectoryView extends HTMLElement
  initialize: (@directory) ->
    @name = @directory.name
    @path = @directory.path

    @classList.add('notebook', 'entry', 'directory', 'collapsed')
    @classList.add('leaf') if @directory.isLeaf

    @entries = document.createElement('ol')
    @entries.classList.add('notebook-list', 'entries')

    @header = document.createElement('div')
    @header.classList.add('header')

    @directoryName = document.createElement('span')
    @directoryName.dataset.name = @directory.name
    @directoryName.title = @directory.name
    @directoryName.textContent = @directory.name

    @header.appendChild(@directoryName)

    @appendChild(@header)
    @appendChild(@entries)

    @expand() if @directory.isExpanded

  toggleExpansion: (isRecursive) ->
    if @isExpanded then @collapse(isRecursive) else @expand(isRecursive)

  expand: (isRecursive = false) ->
    unless @isExpanded
      @isExpanded = true
      @classList.add('expanded')
      @classList.remove('collapsed')
      @directory.expand()

      for name, entry of @directory.entries
        view = @createViewForEntry(entry)
        @entries.appendChild(view) unless !view

      if isRecursive
        for entry in @entries.children when entry instanceof DirectoryView
          entry.expand(true)

  collapse: (isRecursive = false) ->
    @isExpanded = false

    if isRecursive
      for entry in @entries.children when entry.isExpanded
        entry.collapse(true)

    @classList.remove('expanded')
    @classList.add('collapsed')

    @entries.innerHTML = ''

  createViewForEntry: (entry) ->
    if entry instanceof Directory
      view = new DirectoryElement()
    else
      return

    view.initialize(entry)

    view

DirectoryElement = document.registerElement('notebook-view-directory', prototype: DirectoryView.prototype, extends: 'li')
module.exports = DirectoryElement
