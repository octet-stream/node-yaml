const {join} = require("path")

const test = require("ava")

const {normalizePathSync} = require("../../../lib/util/normalizePath")

const fixtures = join(__dirname, "..", "..", "fixture")

test("Returns absolute path as-is", t => {
  const expected = join(fixtures, "read/file.yml")
  const actual = normalizePathSync("/", expected)

  t.is(actual, expected)
})

test("Use given base to resolve relative path", t => {
  const expected = join(fixtures, "read/file.yml")
  const actual = normalizePathSync(fixtures, "read/file.yml")

  t.is(actual, expected)
})

test("Correctly resolves file path without file extension", t => {
  const expected = join(fixtures, "read/file.yml")
  const actual = normalizePathSync(fixtures, "read/file")

  t.is(actual, expected)
})

test("Returns given path when can't match any file", t => {
  const actual = normalizePathSync(fixtures, "foo")

  t.is(actual, join(fixtures, "foo"))
})
