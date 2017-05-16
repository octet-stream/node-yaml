{isNumber} = require "util"

co = require "co"
junk = require "junk"

{readFileSync, writeFileSync, readdirSync} = require "fs"
{readFile, writeFile, readdir} = require "promise-fs"
{dirname, basename, extname, isAbsolute, join, resolve} = require "path"
{parse, load, dump} = yaml = require "js-yaml"

PARSER_SCHEMA =
  defaultSafe: yaml.DEFAULT_SAFE_SCHEMA
  defaultFull: yaml.DEFAULT_FULL_SCHEMA
  failsafe: yaml.FAILSAFE_SCHEMA
  json: yaml.JSON_SCHEMA
  core: yaml.CORE_SCHEMA

YAML_EXT = [".yaml", ".yml"]

PARENT_DIRNAME = dirname module.parent.filename
delete require.cache[__filename]

###
# Fulfill a promised function as callback-style function if it given
#   or return a promise
#
# @param function cb
# @param fn – promised function, wrapped into clojure (see yaml.read method)
#
# @return Promise|undefined
###
fulfill = (cb, fn) ->
  return do fn unless typeof cb is "function"

  onFulfilled = (res) -> cb null, res

  onRejected = (err) -> cb err

  promise = do fn

  promise.then onFulfilled, onRejected

  return

###
# Normalize path to YAML file
# 
# @param string sPath Path to YAML file
#
# @api private
###
normalizePath = (filename) ->
  unless isAbsolute filename
    filename = resolve PARENT_DIRNAME, filename

  base = basename filename
  dir = dirname filename

  files = yield readdir dir

  for file in files when junk.not file
    __ext = extname file
    __base = basename file, __ext

    if base is __base and __ext in YAML_EXT
      return join dir, file

  return filename

###
# Normalize path to YAML file (Synchronously)
# 
# @param string sPath Path to YAML file
#
# @api private
###
normalizePathSync = (filename) ->
  unless isAbsolute filename
    filename = resolve PARENT_DIRNAME, filename

  base = basename filename
  dir = dirname filename

  files = readdirSync dir

  for file in files when junk.not file
    __ext = extname file
    __base = basename file, __ext

    if base is __base and __ext in YAML_EXT
      return join dir, file

  return filename

###
# Normalize options
# 
# @param string|object options
# 
# @return object
#
# @api private
###
normalizeOptions = (options) ->
  unless options?
    return encoding: "utf8", schema: PARSER_SCHEMA.defaultSafe

  options = switch typeof options
    when "string"
      encoding: options
      schema: PARSER_SCHEMA.defaultSafe
    when "object"
      options.encoding or= "utf8"
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
#
# @api private
###
readYamlFile = co.wrap (filename, options = {}) ->
  filename = yield normalizePath filename unless isNumber filename

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
  if typeof options is "function"
    [cb, options] = [options, {}]

  return fulfill cb, -> readYamlFile filename, options

###
# Synchronous version of yaml.read
# 
# @return JSON
###
readSync = (filename, options = {}) ->
  options = normalizeOptions options
  
  filename = normalizePathSync filename unless isNumber filename
  
  content = readFileSync filename, options.encoding
  content = load content, options
  
  return content

###
# Write some content to YAML file with Promise
#
# @api private
###
writeYamlFile = co.wrap (filename, content, options = {}) ->
  filename = yield normalizePath filename unless isNumber filename

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
  if typeof options is "function"
    [cb, options] = [options, {}]

  return fulfill cb, -> writeYamlFile filename, content, options

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
  write
  writeSync
}
