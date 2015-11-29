yaml = require '../index'

yaml.read "#{__dirname}/file", encoding: 'utf8', schema: 'defaultFull', (err, data) ->
	if err
		console.log "!ERR: #{err.message}"
		console.log "!ERR: #{err.errno}"
		console.log "!ERR: #{err.stack}"
		return
	console.log data

# Uncomment for running another tests
# try
# 	console.log yaml.readSync "#{__dirname}/file.yml"
# catch e
# 	console.log "!ERR: #{e.message}"
# 	console.log "!ERR: #{e.errno}"
# 	console.log "!ERR: #{e.stack}"
# data = """
# 	name: Jason Smith
# 	career: DBA
# """
# yaml.write 'out.yml', data, (err) ->
# 	if err
# 		console.log "!ERR: #{err.message}"
# 		console.log "!ERR: #{err.errno}"
# 		console.log "!ERR: #{err.stack}"
# 	console.log 'Done!'
# console.log 'Testing write method.'