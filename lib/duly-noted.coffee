fs = require 'fs'
path = require 'path'
utils = require './utils'

{CompositeDisposable} = require 'atom'

atom.config.onDidChange('duly-noted.noteLocation', (event) ->
  if not fs.existsSync event.newValue
    atom.notifications.addError('Path does not exist: ' + event.newValue)
)

defaultNoteLocation = path.join(utils.getHomeDir(), '.notes')

module.exports =
  notebookView: null

  config:
    noteLocation:
      title: 'Location of notes'
      type: 'string'
      default: defaultNoteLocation
    autosaveEnabled:
      title: 'Autosave notes'
      type: 'boolean'
      default: true
    defaultExtension:
      title: 'Default file extension'
      type: 'string'
      default: '.txt'

  activate: (state) ->
    # Only create the note directory if it matches the default
    if not fs.existsSync(atom.config.get('duly-noted.noteLocation')) and atom.config.get('duly-noted.noteLocation') is defaultNoteLocation
      fs.mkdirSync atom.config.get('duly-noted.noteLocation')
    else if not fs.existsSync(atom.config.get('duly-noted.noteLocation'))
      atom.notifications.addError("Note path does not exist: #{atom.config.get('duly-noted.noteLocation')}")

    @disposables = new CompositeDisposable
    @createView()

    @disposables.add atom.commands.add('atom-workspace', {
      'duly-noted:test': => @createView().test()
      'duly-noted:show': => @createView().show()
      'duly-noted:hide': => @createView().hide()
    })

  createView: ->
    unless @notebookView?
      NotebookView = require './notebook-view'
      @notebookView = new NotebookView(@state)
    @notebookView
