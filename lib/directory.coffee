fs = require 'fs'
path = require 'path'
File = require './file'
_ = require 'underscore'

module.exports =
  class Directory
    constructor: (@name, @path, @isExpanded) ->
      @entries = {}
      @isLeaf = false

      @reload()

    getContents: ->
      names = fs.readdirSync(@path)

      files = []
      directories = []

      for name in names
        fullPath = path.join(@path, name)

        stat = fs.lstatSyncNoException(fullPath)
        if stat.isDirectory?()
          directories.push(new Directory(name, fullPath))
        else if stat.isFile?()
          files.push(new File(name, fullPath))

      @isLeaf = directories.length == 0

      directories.concat(files)

    reload: ->
      newEntries = []
      removedEntries = _.clone(@entries)
      index = 0

      for entry in @getContents()
        if @entries.hasOwnProperty(entry)
          delete removedEntries[entry]
          index++
          continue

        newEntries.push(entry)

      entriesRemoved = false
      for name, entry of removedEntries
        entriesRemoved = true

        if @entries.hasOwnProperty(name)
          delete @entries[name]

      if newEntries.length > 0
        @entries[entry.name] = entry for entry in newEntries

    expand: ->
      @isExpanded = true
      @reload()

    collapse: ->
      @isExpanded = false
