'use strict'

fs = require 'fs'
path = require 'path'
yaml = require 'js-yaml'

exports.schema = PARSER_SCHEMA =
  defaultSafe: yaml.DEFAULT_SAFE_SCHEMA
  defaultFull: yaml.DEFAULT_FULL_SCHEMA
  failsafe: yaml.FAILSAFE_SCHEMA
  json: yaml.JSON_SCHEMA
  core: yaml.CORE_SCHEMA

###
# Normalize path to YAML file
# 
# @param string sPath Path to YAML file
###
normalizePath = (sPath) ->
  YAML_EXT = ['.yml', '.yaml']
  sBasename = path.basename sPath
  sDirname = path.dirname sPath
  aFiles = fs.readdirSync sDirname
  for sFile in aFiles
    __extname = path.extname sFile
    __basename = path.basename sFile, __extname
    if sBasename is __basename and __extname in YAML_EXT
      return sDirname + path.sep + sFile
  return sPath

###
# Normalize options
# 
# @param mixed mOptions
# 
# @return object
###
normalizeOptions = (mOptions) ->
  unless mOptions?
    return encoding: 'utf8', schema: PARSER_SCHEMA.defaultSafe

  return switch typeof mOptions
    when 'string'
      encoding: mOptions
      schema: PARSER_SCHEMA.defaultSafe
    when 'object'
      mOptions.encoding or= 'utf8'
      # mOptions.schema or= PARSER_SCHEMA.defaultSafe
      mOptions.schema = if typeof mOptions.schema is 'string'
        PARSER_SCHEMA[mOptions.schema]
      else
        mOptions.schema or PARSER_SCHEMA.defaultSafe
      mOptions

###
# Parse YAML
# 
# @param string sString YAML string to parse
# @param object|null oOptions options for parser:
#   - schema: object Schema.
#     More information here: https://github.com/nodeca/js-yaml#safeload-string---options-
# Note: defaultSafe schema used by default because is that recomended loading way.
# 
# @return JSON
###
exports.parse = parse = (sString, oOptions = null) ->
  return yaml.load sString, oOptions

###
# Convert JSON into YAML
# 
# @param object JSON to dump
# 
# @return string YAML
###
exports.dump = dump = (oJson, oOptions = null) ->
  return yaml.dump oJson, oOptions

###
# Read and parse YAML file
# 
# @param string|integer mPath Path to YAML file
# @param null|string|object mOptions
# @param Callback
###
exports.read = read = (mPath, mOptions = null, cb) ->
  if typeof mOptions is 'function'
    [cb, mOptions] = [mOptions, null]
  mOptions = normalizeOptions mOptions
  mPath = normalizePath mPath unless typeof mPath is 'number'
  await fs.readFile mPath, mOptions.encoding or null, defer err, mData
  if err?
    cb err
    return
  try
    mData = parse mData, mOptions
  catch err
    cb err
    return
  cb null, mData

###
# Synchronous version of yaml.read
# 
# @return JSON
###
exports.readSync = readSync = (mPath, mOptions = null) ->
  mOptions = normalizeOptions mOptions
  mPath = normalizePath mPath unless typeof mPath is 'number'
  mData = fs.readFileSync mPath, mOptions.encoding or null
  mData = parse mData, mOptions
  return mData

###
# Parse and write YAML to file
# 
# @param string sPath Path to YAML file
# @param string|Buffer Data to write
# @param null|string|options mOptions
# @param Callback
###
exports.write = write = (mPath, mData = '', mOptions = null, cb) ->
  if typeof mOptions is 'function'
    [cb, mOptions] = [mOptions, null]
  mOptions = normalizeOptions mOptions
  try
    mData = dump mData, mOptions
  catch err
    cb err
    return
  await fs.writeFile mPath, mData, mOptions.encoding or null, defer err
  if err?
    cb err
    return
  cb null

###
# Synchronous version of yaml.write
# 
# @return Return undefined when file has been successfully written
###
exports.writeSync = writeSync = (mPath, mData = '', mOptions = null) ->
  mOptions = normalizeOptions mOptions
  mData = dump mData
  fs.writeFileSync mPath, mData, mOptions.encoding or null

# Create custom type
exports.Type = yaml.Type

# Create custon schema
exports.createSchema = yaml.Schema.create