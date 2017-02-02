fs = require 'fs'
path = require 'path'
File = require './file'

module.exports =
  class Directory
    constructor: (@name, @path) ->
      @entries = @getContents()

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

      directories.concat(files)
