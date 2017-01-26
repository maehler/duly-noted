exports.getHomeDir = ->
  process.env[if process.platform == 'win32' then 'USERPROFILE' else 'HOME']
