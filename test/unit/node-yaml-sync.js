const {join} = require("path")

const {spy} = require("sinon")

const test = require("ava")
const pq = require("proxyquire")
const fs = require("promise-fs")
const yaml = require("js-yaml")

const {readSync} = require("../../lib/node-yaml")

const fixtures = join(__dirname, "..", "fixture")

test("yaml.read() reads file from disk and returns its content", t => {
  const expected = yaml.safeLoad(
    fs.readFileSync(join(fixtures, "read/file.yml"), "utf8")
  )

  const actual = readSync(join(fixtures, "read", "file"))

  t.deepEqual(actual, expected)
})

test("yaml.read() takes file descriptor to read it from disk", t => {
  const fd = fs.openSync(join(fixtures, "read", "file.yml"), "r")

  const expected = yaml.safeLoad(
    fs.readFileSync(join(fixtures, "read/file.yml"), "utf8")
  )

  const actual = readSync(fd)

  t.deepEqual(actual, expected)

  fs.close(fd)
})

test("yaml.write() writes file to disk", t => {
  const writeFileSync = spy(() => Promise.resolve(undefined))

  const {writeSync} = pq("../../lib/node-yaml", {
    "promise-fs": {
      writeFileSync
    }
  })

  const expected = yaml.safeDump({key: "value"})

  writeSync(join(fixtures, "write/file.yml"), {key: "value"})

  const [, actual] = writeFileSync.firstCall.args

  t.is(actual, expected)
})

test("yaml.write() use file descriptor to safe the content", t => {
  const writeFileSync = spy(() => Promise.resolve(undefined))

  const {writeSync} = pq("../../lib/node-yaml", {
    "promise-fs": {
      writeFileSync
    }
  })

  const fd = 42

  writeSync(fd, {key: "value"})

  const [actual] = writeFileSync.firstCall.args

  t.is(actual, fd)
})
