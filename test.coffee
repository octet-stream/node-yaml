test = require "ava"

co = require "co"

yaml = require "."

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

test.cb "Should read a file and resolve to a given callback", (t) ->
  t.plan 1

  expectedContent =
    unicode: "Sosa did fine.☺"
    control: "\b1998\t1999\t2000\n"
    "hex esc": "\r\n is \r\n",
    single: "\"Howdy!\" he cried."
    quoted: " # Not a 'comment'."
    "tie-fighter": "|\\-*-/|"

  fulfill = (err, actualContent) ->
    return t.fail err if err?

    t.deepEqual actualContent, expectedContent

    do t.end

  yaml.read "#{__dirname}/test/file", fulfill
