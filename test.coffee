test = require "ava"

co = require "co"
isPlainObject = require "lodash.isplainobject"

yaml = require "."
jsyaml = require "js-yaml"

test "Should return an object", (t) ->
  t.plan 1

  t.true isPlainObject yaml

  return

test "Should read a simple file from an absolute path", co.wrap (t) ->
  expectedContent =
    unicode: "Sosa did fine.☺"
    control: "\b1998\t1999\t2000\n"
    "hex esc": "\r\n is \r\n",
    single: "\"Howdy!\" he cried."
    quoted: " # Not a 'comment'."
    "tie-fighter": "|\\-*-/|"

  actualContent = yield yaml.read "#{__dirname}/test/file"

  t.deepEqual actualContent, expectedContent
