COLOR_DEF = "\x1b[0m"
COLOR_RED = '\x1B[0;31m'

fs = require 'fs'
yaml = require '../index'

sexyType = new yaml.Type '!sexy',
  # See node kinds in YAML spec: http://www.yaml.org/spec/1.2/spec.html#kind//
  kind: 'sequence',
  construct: (data) -> data.map (string) -> "sexy #{string}"
sexySchema = yaml.createSchema [sexyType]

# Asynchronous method:
yaml.read "#{__dirname}/custom-schema",
  schema: sexySchema,
  (err, data) ->
    if err
      console.log "#{COLOR_RED}!ERR#{COLOR_DEF}: #{err.message}"
      console.log "#{COLOR_RED}!ERR#{COLOR_DEF}: #{err.errno}" if err.errno
      console.log "#{COLOR_RED}!ERR#{COLOR_DEF}: #{err.stack}"
      return
    console.log data

# Synchronous method:
try
  fd = fs.openSync "#{__dirname}/file.yml", 'r' # Get fd :)
  console.log "File descriptor: #{fd}"
  console.log 'Reading file by file descriptor:'
  console.log yaml.readSync fd,
    encoding: 'utf8'
    schema: yaml.schema.defaultSafe
  console.log ''
catch e
  console.log "#{COLOR_RED}!ERR#{COLOR_DEF}: #{e.message}"
  console.log "#{COLOR_RED}!ERR#{COLOR_DEF}: #{e.errno}" if err.errno
  console.log "#{COLOR_RED}!ERR#{COLOR_DEF}: #{e.stack}"


# Reading with Promise
yaml.readPromise "./file.yml"
  .then (mData) ->
    console.log ''
    console.log 'Reading with Promise:'
    console.log mData
  .catch (err) ->
    console.log "#{COLOR_RED}!ERR#{COLOR_DEF}: #{err.message}"
    console.log "#{COLOR_RED}!ERR#{COLOR_DEF}: #{err.errno}" if err.errno
    console.log "#{COLOR_RED}!ERR#{COLOR_DEF}: #{err.stack}"

console.log ''
console.log 'Asynchronous methods:'

# Uncomment for run another tests

# console.log '\nTesting yaml.write and yaml.writeSync methods\n'
# data =
#   name: 'Jason Smith'
#   career: 'DBA'

# yaml.write 'async-out.yml', data, (err) ->
#   if err
#     console.log "#{COLOR_RED}!ERR#{COLOR_DEF}: #{err.message}"
#     console.log "#{COLOR_RED}!ERR#{COLOR_DEF}: #{err.errno}" if err.errno
#     console.log "#{COLOR_RED}!ERR#{COLOR_DEF}: #{err.stack}"
#   console.log 'Asynchronouts write done.'

# try
#   yaml.writeSync 'sync-out.yaml', data
#   console.log 'Synchronous read done.'
# catch e
#   console.log "#{COLOR_RED}!ERR#{COLOR_DEF}: #{e.message}"
#   console.log "#{COLOR_RED}!ERR#{COLOR_DEF}: #{e.errno}" if err.errno
#   console.log "#{COLOR_RED}!ERR#{COLOR_DEF}: #{e.stack}"

# # Writing with promise
# yaml.writePromise 'promise-out.yaml', data
#   .then ->
#     console.log "Written with promise in promise-out.yaml"
#   .catch (err) ->
#     console.log "#{COLOR_RED}!ERR#{COLOR_DEF}: #{err.message}"
#     console.log "#{COLOR_RED}!ERR#{COLOR_DEF}: #{err.errno}" if err.errno
#     console.log "#{COLOR_RED}!ERR#{COLOR_DEF}: #{err.stack}"
