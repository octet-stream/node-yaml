{dirname, basename, extname, isAbsolute, join, resolve} = require "path"
{readFileSync, writeFileSync, readdirSync} = require "fs"

co = require "co"
junk = require "junk"

{parse, load, dump} = yaml = require "js-yaml"
{readFile, writeFile, readdir} = require "promise-fs"

PARSER_SCHEMA =
  defaultSafe: yaml.DEFAULT_SAFE_SCHEMA
  defaultFull: yaml.DEFAULT_FULL_SCHEMA
  failsafe: yaml.FAILSAFE_SCHEMA
  json: yaml.JSON_SCHEMA
  core: yaml.CORE_SCHEMA

YAML_EXT = [".yaml", ".yml"]

isString = (val) -> typeof val is "string"

isNumber = (val) -> typeof val is "nubmber"

if module.parent? and isString module.parent.filename
  PARENT_DIRNAME = dirname module.parent.filename
  delete require.cache[__filename]
else
  PARENT_DIRNAME = do process.cwd

###
# Fulfill a promised function as callback-style function if it given
#   or return a promise
#
# @param {function} cb
# @param {fn} – promised function, wrapped into clojure (see yaml.read method)
#
# @return {void | Promise<any>}
*
* @api private
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
# @param {string} filename – Path to YAML file
#
# @return {Promise<string>}
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
# @param {string} filename - path to YAML file
#
# @return {string}
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
# @param {string | object} [options = {null}]
#
# @return {object}
#
# @api private
###
normalizeOptions = (options = {}) ->
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
# @param {number | string} filename - path or file descriptor
# @param {object} [options = null]
#
# @return {Promise<object>}
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
# @param {number | string} filename - path or file descriptor
# @param {object} [options = null]
# @param {function} [cb = null]
#
# @return {void | Promise<object>}
###
read = (filename, options = {}, cb = null) ->
  if typeof options is "function"
    [cb, options] = [options, {}]

  return fulfill cb, -> readYamlFile filename, options

###
# Synchronous version of yaml.read
#
# @param {string | number} filename – path or file descriptor
# @param {string | object} [options = {}]
#
# @return {object}
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
# @param {string | number} – path or file descriptor
# @param {any} content – a file contents
# @param {string | object} [options = {}]
#
# @return {void | Promise<void>}
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
# @param int|string filename - path or file descriptor
# @param object content - File content
# @param object options
# @param function cb
#
# @return {void | Promise<void>}
###
write = (filename, content, options = {}, cb = null) ->
  if typeof options is "function"
    [cb, options] = [options, {}]

  return fulfill cb, -> writeYamlFile filename, content, options

###
# Synchronous version of yaml.write
#
# @param {string | number} filename – path or file descriptor
# @param {any} content – a file contents
#
# @return {void}
###
writeSync = (filename, content, options = {}) ->
  filename = normalizePathSync filename
  options = normalizeOptions options
  content = dump content

  writeFileSync filename, content, options.encoding or null

  return

module.exports = {
  parser: yaml
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
