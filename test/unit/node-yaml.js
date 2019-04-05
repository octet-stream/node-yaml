const {join} = require("path")

const test = require("ava")

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
