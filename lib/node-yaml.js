const {dirname} = require("path")

const fs = require("promise-fs")
const yaml = require("js-yaml")

const isNumber = require("./util/isNumber")
const toAbsolute = require("./util/toAbsolute")
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
 * @param {string | number} filename
 * @param {string | object} [options = undefined]
 *
 * @param {string}
 *
 * @return {Promise<object>}
 *
 * @api public
 */
async function read(filename, options = undefined) {
  const {encoding, flag, ...opts} = normalizeOptions(options)

  if (!isNumber(filename)) {
    filename = await normalizePath(base, filename)

    opts.filename = filename
  }

  const content = await fs.readFile(filename, {encoding, flag})

  return yaml.load(content, opts)
}

/**
 * Read and parse YAML file from given path (synchronously)
 *
 * @param {string | number} filename
 * @param {options} [options = undefined]
 *
 * @return {object}
 *
 * @api public
 */
function readSync(filename, options = undefined) {
  const {encoding, flag, ...opts} = normalizeOptions(options)

  if (!isNumber(filename)) {
    filename = normalizePathSync(base, filename)

    opts.filename = filename
  }

  const content = fs.readFileSync(filename, {encoding, flag})

  return yaml.load(content, opts)
}

/**
 * Write given YAML content to disk
 *
 * @param {string | number} filename
 * @param {object} object
 * @param {options} [options = undefined]
 *
 * @return {void}
 *
 * @api public
 */
async function write(filename, object, options = undefined) {
  const {encoding, flag, ...opts} = normalizeOptions(options)

  if (!isNumber(filename)) {
    filename = toAbsolute(base, filename)

    opts.filename = filename
  }

  await fs.writeFile(filename, yaml.dump(object, opts), {encoding, flag})
}

/**
 * Write given YAML object to disk (synchronously)
 *
 * @param {string | number} filename
 * @param {object} object
 * @param {options} [options = undefined]
 *
 * @return {void}
 *
 * @api public
 */
function writeSync(filename, object, options = undefined) {
  const {encoding, flag, ...opts} = normalizeOptions(options)

  if (!isNumber(filename)) {
    filename = toAbsolute(base, filename)

    opts.filename = filename
  }

  fs.writeFileSync(filename, yaml.dump(object, opts), {encoding, flag})
}

exports.read = read
exports.readSync = readSync
exports.write = write
exports.writeSync = writeSync
exports.default = exports
