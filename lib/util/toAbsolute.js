const {resolve, isAbsolute} = require("path")

/**
 * @api private
 */
const toAbsolute = (base, path) => isAbsolute(path) ? path : resolve(base, path)

module.exports = toAbsolute
