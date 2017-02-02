class DirectoryView extends HTMLElement
  initialize: (@directory) ->
    @name = @directory.name
    @path = @directory.path

    @directoryName = document.createElement('span')
    @directoryName.dataset.name = @directory.name
    @directoryName.title = @directory.name
    @directoryName.textContent = @directory.name

    @appendChild(@directoryName)

DirectoryElement = document.registerElement('notebook-view-directory', prototype: DirectoryView.prototype, extends: 'li')
module.exports = DirectoryElement
