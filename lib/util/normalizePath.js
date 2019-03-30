const {basename, dirname, extname, join, resolve, isAbsolute} = require("path")

const fs = require("promise-fs")
const junk = require("junk")

const EXT = [".yaml", ".yml"]

/**
 * @api private
 */
const toAbsolute = (base, path) => isAbsolute(path) ? path : resolve(base, path)

/**
 * @api private
 */
const find = (name, files) => files.find(
  file => basename(file, extname(file)) === name
)

/**
 * @api private
 */
const filter = array => array.filter(junk.not)

/**
 * @api private
 */
function assertExtname(ext) {
  if (!EXT.includes(ext)) {
    throw new Error(`Unsupported file extension: ${ext}`)
  }
}

/**
 * @api private
 */
function normalizePathSync(base, path) {
  path = toAbsolute(base, path)

  const ext = extname(path)
  const dir = dirname(path)

  if (ext) {
    assertExtname(ext)

    return path
  }

  const files = filter(fs.readdirSync(dir))
  const file = find(basename(path), files)

  if (!file) {
    return path
  }

  return join(dir, file)
}

/**
 * @api private
 */
async function normalizePath(base, path) {
  path = toAbsolute(base, path)

  const ext = extname(path)
  const dir = dirname(path)

  if (ext) {
    assertExtname(ext)

    return path
  }

  const files = await fs.readdir(dir).then(filter)
  const file = find(basename(path), files)

  if (!file) {
    return path
  }

  return join(dir, file)
}

exports.normalizePath = normalizePath
exports.normalizePathSync = normalizePathSync
