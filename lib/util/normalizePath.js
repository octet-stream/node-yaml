const {basename, dirname, extname, join} = require("path")

const fs = require("promise-fs")
const junk = require("junk")

const toAbsolute = require("./toAbsolute")

const EXT = [".yaml", ".yml"]

/**
 * @api private
 */
const find = (name, list) => list.find(file => {
  const ext = extname(file)

  return EXT.includes(ext) && basename(file, ext) === name
})

/**
 * @api private
 */
const filter = array => array.filter(junk.not)

/**
 * @api private
 */
async function normalizePath(base, path) {
  path = toAbsolute(base, path)

  const ext = extname(path)
  const dir = dirname(path)

  if (ext) {
    return path
  }

  const files = await fs.readdir(dir).then(filter)
  const file = find(basename(path), files)

  if (!file) {
    return path
  }

  return join(dir, file)
}

/**
 * @api private
 */
function normalizePathSync(base, path) {
  path = toAbsolute(base, path)

  const ext = extname(path)
  const dir = dirname(path)

  if (ext) {
    return path
  }

  const files = filter(fs.readdirSync(dir))
  const file = find(basename(path), files)

  if (!file) {
    return path
  }

  return join(dir, file)
}

exports.normalizePath = normalizePath
exports.normalizePathSync = normalizePathSync
