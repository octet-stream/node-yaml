const {dirname} = require("path")

const fs = require("promise-fs")
const yaml = require("js-yaml")

const isNumber = require("./util/isNumber")
const isPlainObject = require("./util/isPlainObject")

const {normalizePath, normalizePathSync} = require("./util/normalizePath")

let base = process.cwd()
if (module.parent && typeof module.parent.filename === "string") {
  base = dirname(module.parent.filename)

  // eslint-disable-next-line no-underscore-dangle
  delete require.cache[__filename]
}

const defaults = {
  schema: yaml.DEFAULT_SAFE_SCHEMA,
  encoding: "utf8"
}

/**
 * @param {string | object} options
 *
 * @return {object}
 *
 * @api private
 */
function normalizeOptions(options = undefined) {
  switch (true) {
    case isPlainObject(options):
      return {
        ...defaults, ...options
      }

    case options && typeof options === "string":
      return {
        ...defaults, encoding: options
      }

    default:
      return defaults
  }
}

/**
 * Read and parse YAML file from given path
 *
 * @param {string} path
 * @param {string | object} [options = undefined]
 *
 * @param {string}
 *
 * @return {Promise<object>}
 *
 * @api public
 */
async function read(path, options = undefined) {
  const {encoding, ...opts} = normalizeOptions(options)

  if (!isNumber(path)) {
    path = await normalizePath(base, path)
  }

  const content = await fs.readFile(path, encoding)

  return yaml.load(content, opts)
}

/**
 * Read and parse YAML file from given path (synchronously)
 *
 * @param {string} path
 * @param {options} [options = undefined]
 *
 * @return {object}
 *
 * @api public
 */
function readSync(path, options = undefined) {
  const {encoding, ...opts} = normalizeOptions(options)

  if (!isNumber(path)) {
    path = normalizePathSync(base, path)
  }

  const content = fs.readFileSync(path, encoding)

  return yaml.load(content, opts)
}

/**
 * Write given YAML content to disk
 *
 * @param {string} path
 * @param {object} content
 * @param {options} [options = undefined]
 *
 * @return {void}
 *
 * @api public
 */
async function write(path, content, options = undefined) {
  const {encoding, ...opts} = normalizeOptions(options)

  if (!isNumber(path)) {
    path = await normalizePath(base, path)
  }

  await fs.writeFile(path, yaml.dump(content, opts), encoding)
}

/**
 * Write given YAML content to disk (synchronously)
 *
 * @param {string} path
 * @param {object} content
 * @param {options} [options = undefined]
 *
 * @return {void}
 *
 * @api public
 */
function writeSync(path, content, options = undefined) {
  const {encoding, ...opts} = normalizeOptions(options)

  if (!isNumber(path)) {
    path = normalizePathSync(base, path)
  }

  fs.writeFileSync(path, yaml.dump(content, opts), encoding)
}

exports.read = read
exports.readSync = readSync
exports.write = write
exports.writeSync = writeSync
exports.default = exports
