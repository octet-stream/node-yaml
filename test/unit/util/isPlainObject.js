const test = require("ava")

const isPlainObject = require("../../../lib/util/isPlainObject")

test("Should return true when object literal given", t => {
  t.plan(1)

  t.true(isPlainObject({}))
})

test("Should return true when Object.create(null) result given", t => {
  t.plan(1)

  t.true(isPlainObject(Object.create(null)))
})

test("Should return false when array-like object given", t => {
  t.plan(1)

  t.false(isPlainObject([]))
})

test("Should return false when any other non-plain object passed", t => {
  t.plan(3)

  class Noop {}

  t.false(isPlainObject(new Map()))
  t.false(isPlainObject(new Noop()))
  t.false(isPlainObject(/[a-z0-9-_]+/i))
})

test("Should return false when scalar type given", t => {
  t.plan(5)

  t.false(isPlainObject(null))
  t.false(isPlainObject(undefined))
  t.false(isPlainObject(true))
  t.false(isPlainObject(42))
  t.false(isPlainObject("noop"))
})
