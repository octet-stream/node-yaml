const {join} = require("path")

const {spy} = require("sinon")

const test = require("ava")
const pq = require("proxyquire")
const fs = require("promise-fs")
const yaml = require("js-yaml")

const {read} = require("../../lib/node-yaml")

const fixtures = join(__dirname, "..", "fixture")

test("yaml.read() reads file from disk and returns its content", async t => {
  const expected = await fs.readFile(join(fixtures, "read/file.yml"), "utf8")
    .then(yaml.safeLoad)

  const actual = await read(join(fixtures, "read", "file"))

  t.deepEqual(actual, expected)
})

test("yaml.read() takes file descriptor to read it from disk", async t => {
  const fd = await fs.open(join(fixtures, "read", "file.yml"), "r")

  const expected = await fs.readFile(join(fixtures, "read/file.yml"), "utf8")
    .then(yaml.safeLoad)

  const actual = await read(fd)

  t.deepEqual(actual, expected)

  await fs.close(fd)
})

test("yaml.write() writes file to disk", async t => {
  const writeFile = spy(() => Promise.resolve(undefined))

  const {write} = pq("../../lib/node-yaml", {
    "promise-fs": {
      writeFile
    }
  })

  const expected = yaml.safeDump({key: "value"})

  await write(join(fixtures, "write/file.yml"), {key: "value"})

  const [, actual] = writeFile.firstCall.args

  t.is(actual, expected)
})

test("yaml.write() use file descriptor to safe the content", async t => {
  const writeFile = spy(() => Promise.resolve(undefined))

  const {write} = pq("../../lib/node-yaml", {
    "promise-fs": {
      writeFile
    }
  })

  const fd = 42

  await write(fd, {key: "value"})

  const [actual] = writeFile.firstCall.args

  t.is(actual, fd)
})
