class FileView extends HTMLElement
  initialize: (@file) ->
    @name = @file.name
    @path = @file.path

    @classList.add('note')

    fileName = document.createElement('span')
    fileName.textContent = @name

    @appendChild(fileName)

FileElement = document.registerElement('notebook-view-file', prototype: FileView.prototype, extends: 'li')
module.exports = FileElement
