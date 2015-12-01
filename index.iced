'use strict'

fs = require 'fs'
path = require 'path'
yaml = require 'js-yaml'

PARSER_SCHEMA =
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
	dirname = path.dirname sPath
	files = fs.readdirSync dirname
	return dirname + path.sep + file for file in files when sBasename == path.basename(file, YAML_EXT[0]) or sBasename == path.basename(file, YAML_EXT[1]) and path.extname(file) in YAML_EXT
	return sPath

###
# Parse YAML
# 
# @param string sString YAML string to parse
# @param object|null oOptions options for parser:
# 	- schema: object Schema. More information here: https://github.com/nodeca/js-yaml#safeload-string---options-
# note: defaultSafe schema used by default because is that recomended loading way.
# 
# @return JSON
###
exports.parse = parse = (sString, oOptions = null) ->
	if oOptions?
		oOptions.schema = if Object.keys(oOptions).length > 0 then PARSER_SCHEMA[oOptions.schema] else PARSER_SCHEMA['defaultSafe']
	return yaml.load sString, oOptions

###
# Convert JSON into YAML
# 
# @param object JSON to dump
# 
# @return string YAML
###
exports.dump = dump = (oJson, oOptions = null) ->
	if oOptions?
		oOptions.schema = if Object.keys(oOptions).length > 0 then PARSER_SCHEMA[oOptions.schema] else PARSER_SCHEMA['defaultSafe']
	return yaml.dump oJson, oOptions
###
# Read and parse YAML file
# 
# @param string|integer mPath Path to YAML file (It can be provided without extname) or file descriptor
# @param null|string|object mOptions
# @param Callback
###
exports.read = read = (mPath, mOptions, cb) ->
	if typeof mOptions is 'function'
		cb = mOptions
	else if typeof mOptions is 'string'
		[encoding, mOptions] = [mOptions, null]
	else if typeof mOptions is 'object' and Array.isArray isnt yes
		if mOptions.encoding?
			encoding = mOptions.encoding
			delete mOptions.encoding
	mPath = normalizePath mPath unless typeof mPath is 'number'
	await fs.readFile mPath, encoding, defer err, mData
	return cb err if err?
	try
		mData = parse mData, mOptions
	catch e
		return cb e
	cb null, mData

###
# Synchronous version of yaml.read
# 
# @return JSON
###
exports.readSync = readSync = (mPath, mOptions = null) ->
	if typeof mOptions is 'string'
		[encoding, mOptions] = [mOptions, null]
	else if mOptions? and typeof mOptions is 'object' and Array.isArray isnt yes
		if mOptions.encoding?
			encoding = mOptions.encoding
			delete mOptions.encoding
	mPath = normalizePath mPath unless typeof mPath is 'number'
	mData = fs.readFileSync mPath, encoding
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
		cb = mOptions
	else if typeof mOptions is 'string'
		[encoding, mOptions] = [mOptions, null]
	else if typeof mOptions is 'object' and Array.isArray isnt yes
		if mOptions.encoding?
			encoding = mOptions.encoding
			delete mOptions.encoding
	try
		mData = dump mData, mOptions
	catch e
		return cb e
	await fs.writeFile mPath, mData, encoding, defer err
	return cb err if err?
	cb null

###
# Synchronous version of yaml.write
# 
# @return Returns null if file has successfully written
###
exports.writeSync = writeSync = (mPath, mData = '', mOptions = null, cb) ->
	if typeof mOptions is 'string'
		[encoding, mOptions] = [mOptions, null]
	else if mOptions? and typeof mOptions is 'object' and Array.isArray isnt yes
		if mOptions.encoding?
			encoding = mOptions.encoding
			delete mOptions.encoding
	mData = dump mData
	fs.writeFileSync mPath, mData, encoding
	return null

# Experemental
exports.Schema = yaml.Schema