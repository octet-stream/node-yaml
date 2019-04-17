# Node YAML

A wrapper for [js-yaml](https://github.com/nodeca/js-yaml) parser

[![dependencies Status](https://david-dm.org/octet-stream/node-yaml/status.svg)](https://david-dm.org/octet-stream/node-yaml)
[![devDependencies Status](https://david-dm.org/octet-stream/node-yaml/dev-status.svg)](https://david-dm.org/octet-stream/node-yaml?type=dev)
[![Build Status](https://travis-ci.org/octet-stream/node-yaml.svg?branch=master)](https://travis-ci.org/octet-stream/node-yaml)
[![Code Coverage](https://codecov.io/github/octet-stream/node-yaml/coverage.svg?branch=master)](https://codecov.io/github/octet-stream/node-yaml?branch=master)

This documentation is actual for next major version of the library.
If you want the documentation of current stable version, please check out the [3.x](https://github.com/octet-stream/node-yaml/tree/3.x) branch.

## Installation

You can install this module from Yarn:

```
yarn add node-yaml js-yaml
```

Or using NPM:

```
npm install node-yaml js-yaml
```

## Usage

1. Let's read some file from given path using node-yaml:

```js
import {read} from "node-yaml"

read("path/to/file.yaml")
  .then(res => console.log("File content:\n\n%s", JSON.stringify(res, null, 2)))
  .catch(err => console.error("Error while reading file:\n\n%s", String(err)))
```

2. Both `read` and `readSync` methods allows to omit file extension:

```js
import {readSync} from "node-yaml"

// Will read the content from given path, but also resolve file extension
// Note that if you have 2 files with the same name,
// the first matched will be read.
readSync("path/to/file")
```

## API

##### `yaml.read(filename[, options]) -> {Promise<object>}`

Read and parse YAML file from given path. Takes following arguments:

- **{string | number}** filename – path to file or a file descriptor. Path can omit the file extension.
- **{object}** {options = undefined} – reading options
  + **{string}** [options.encoding = "utf8"] – an encoding used to read the file
  + more options you can find in js-yaml docs in [safeLoad](https://github.com/nodeca/js-yaml#safeload-string---options-) section

##### `yaml.readSync(filename[, options]) -> {object}`

Synchronous version of **yaml.read**

##### `yaml.write(filename, object[, options]) -> {Promise<void>}`

Write given YAML content to disk. Takes following arguments:

- **{string | number}** filename – path to file or a file descriptor. Path can omit the file extension.
- **{object}** object – a content to write to the file
- **{object}** {options = undefined} – writing options
  + **{string}** [options.encoding = "utf8"] – an encoding used to write to the file
  + more options you can find in js-yaml docs in [safeDump](https://github.com/nodeca/js-yaml#safedump-object---options-) section

##### `yaml.writeSync(filename, object[, options]) -> {void}`

Synchronous version of **yaml.write**
