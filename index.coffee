co = require 'co'
{readFileSync, writeFileSync, readdirSync} = require 'fs'
{readFile, writeFile, readdir} = require 'co-fs'
{dirname, basename, extname, sep, isAbsolute, join} = require 'path'
{parse, load, dump} = yaml = require 'js-yaml'

PARSER_SCHEMA =
  defaultSafe: yaml.DEFAULT_SAFE_SCHEMA
  defaultFull: yaml.DEFAULT_FULL_SCHEMA
  failsafe: yaml.FAILSAFE_SCHEMA
  json: yaml.JSON_SCHEMA
  core: yaml.CORE_SCHEMA

YAML_EXT = ['.yaml', '.yml']

PARENT_DIRNAME = dirname module.parent.filename

###
# Normalize path to YAML file
# 
# @param string sPath Path to YAML file
###
normalizePath = (filename) ->
  unless isAbsolute filename
    filename = "#{PARENT_DIRNAME}/#{basename filename}"

  base = basename filename
  dir = dirname filename

  files = yield readdir dir
  for file in files when file isnt '.DS_Store'
    __extname = extname file
    __basename = basename file, __extname
    if base is __basename and __extname in YAML_EXT
      return "#{dir}#{sep}#{file}"

  return filename

###
# Normalize path to YAML file (Synchronously)
# 
# @param string sPath Path to YAML file
###
normalizePathSync = (filename) ->
  unless isAbsolute filename
    filename = join PARENT_DIRNAME, filename


  base = basename filename
  dir = dirname filename

  files = readdirSync dir
  for file in files when file isnt '.DS_Store'
    __extname = extname file
    __basename = basename file, __extname
    if base is __basename and __extname in YAML_EXT
      return "#{dir}#{sep}#{file}"

  return filename

###
# Normalize options
# 
# @param string|object options
# 
# @return object
###
normalizeOptions = (options) ->
  unless options?
    return encoding: 'utf8', schema: PARSER_SCHEMA.defaultSafe

  options = switch typeof options
    when 'string'
      encoding: options
      schema: PARSER_SCHEMA.defaultSafe
    when 'object'
      options.encoding or= 'utf8'
      options.schema or= PARSER_SCHEMA.defaultSafe
      options

  return options

###
# Read YAML file with Promise
#
# @param int|string filename - File descriptor or path
# @param null|object options
#
# @return Promise
###
readPromise = (filename, options = {}) ->
  return co ->
    filename = yield normalizePath filename unless typeof filename is 'number'
    options = normalizeOptions options
    content = yield readFile filename, options.encoding
    return load content, options

###
# Read and parse YAML file
# Note: Returns an instance of Promise unless callback given
# 
# @param int|string filename - File descriptor or path
# @param null|object options
# @param function cb
###
read = (filename, options = {}, cb = null) ->
  if typeof options is 'function'
    [cb, options] = [options, {}]

  __promise = readPromise filename, options
  unless typeof cb is 'function'
    return __promise

  __promise
    .then (content) -> cb null, content
    .catch (err) -> cb err

###
# Synchronous version of yaml.read
# 
# @return JSON
###
readSync = (filename, options = {}) ->
  options = normalizeOptions options
  filename = normalizePathSync filename unless typeof filename is 'number'
  content = readFileSync filename, options.encoding
  content = load content, options
  return content

###
# Write some content to YAML file with Promise
###
writePromise = (filename, content, options = {}) ->
  return co ->
    filename = yield normalizePath filename unless typeof filename is 'number'
    options = normalizeOptions options
    content = dump content, options
    yield writeFile filename, content, options
    return

###
# Write some content to YAML file
# Note: Returns an instance of Promise unless callback given
#
# @param int|string filename - File descriptor or path
# @param object content - File content
# @param object options
# @param function cb
###
write = (filename, content, options = {}, cb = null) ->
  if typeof options is 'function'
    [cb, options] = [options, {}]

  __promise = writePromise filename, content, options
  unless typeof cb is 'function'
    return __promise

  __promise
    .then (content) -> cb null
    .catch (err) -> cb err

###
# Synchronous version of yaml.write
###
writeSync = (filename, content, options = null) ->
  filename = normalizePathSync filename
  options = normalizeOptions options
  content = dump content
  writeFileSync filename, content, options.encoding or null
  return

module.exports = {
  Type: yaml.Type
  createSchema: yaml.Schema.create
  schema: PARSER_SCHEMA
  parse: load
  dump
  read
  readSync
  readPromise
  write
  writeSync
  writePromise
}
