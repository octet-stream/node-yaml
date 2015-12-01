COLOR_DEF = "\x1b[0m"
COLOR_RED = '\x1B[0;31m'

fs = require 'fs'
yaml = require '../index'

# Asynchronous method:
yaml.read "#{__dirname}/file", encoding: 'utf8', schema: 'defaultFull', (err, data) ->
	if err
		console.log "!ERR: #{err.message}"
		console.log "!ERR: #{err.errno}"
		console.log "!ERR: #{err.stack}"
		return
	console.log data

try
	# Synchronous method:
	fd = fs.openSync "#{__dirname}/file.yml", 'r' # Get fd :)
	console.log "File descriptor: #{fd}"
	console.log 'Read file by file descriptor:'
	console.log yaml.readSync fd
catch e
	console.log "#{COLOR_RED}!ERR#{COLOR_DEF}: #{e.message}"
	console.log "#{COLOR_RED}!ERR#{COLOR_DEF}: #{e.errno}"
	console.log "#{COLOR_RED}!ERR#{COLOR_DEF}: #{e.stack}"

console.log ''
console.log 'Asynchronous method:'

# Uncomment for running another tests
# data =
# 	name: 'Jason Smith'
# 	career: 'DBA'
# yaml.write 'out.yml', data, (err) ->
# 	if err
# 		console.log "!ERR: #{err.message}"
# 		console.log "!ERR: #{err.errno}"
# 		console.log "!ERR: #{err.stack}"
# 	console.log 'Done!'
# console.log 'Testing write method.'