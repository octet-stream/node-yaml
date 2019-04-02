const {join} = require("path")

const test = require("ava")

const {normalizePath} = require("../../../lib/util/normalizePath")

const fixtures = join(__dirname, "..", "..", "fixture")

test("Returns absolute path as-is", async t => {
  const expected = join(fixtures, "read/file.yml")
  const actual = await normalizePath("/", expected)

  t.is(actual, expected)
})

test("Use given base to resolve relative path", async t => {
  const expected = join(fixtures, "read/file.yml")
  const actual = await normalizePath(fixtures, "read/file.yml")

  t.is(actual, expected)
})

test("Correctly resolves file path without file extension", async t => {
  const expected = join(fixtures, "read/file.yml")
  const actual = await normalizePath(fixtures, "read/file")

  t.is(actual, expected)
})

test("Returns given path when can't match any file", async t => {
  const actual = await normalizePath(fixtures, "foo")

  t.is(actual, join(fixtures, "foo"))
})
