# Node YAML

A wrapper for [js-yaml](https://github.com/nodeca/js-yaml) parser

## Installation

You can install this module from Yarn:

```
  yarn add node-yaml js-yaml
```

Or using NPM:

```
npm install node-yaml js-yaml
```

### Usage

Let's read some file from given path using node-yaml:

```js
import yaml from "node-yaml"

yaml.read("path/to/file.yaml")
  .then(res => console.log("File content:\n\n%s", JSON.stringify(res, null, 2)))
  .catch(err => console.error("Error while reading file:\n\n%s", String(err)))
```

## API

### `yaml.read(filename[, options]) -> {Promise<object>}`

Read and parse YAML file from given path. Takes following arguments:

- **{string | number}** filename – path to file or a file descriptor. Path can omit the file extension.
- **{object}** {options = undefined} – reading options
  + **{string}** [options.encoding = "utf8"] – an encoding used to read the file
  + more options you can find in js-yaml docs in [safeLoad](https://github.com/nodeca/js-yaml#safeload-string---options-) section

### `yaml.readSync(filename[, options]) -> {object}`

Synchronous version of **yaml.read**

### `yaml.write(filename, object[, options]) -> {void}`

Write given YAML content to disk. Takes following arguments:

- **{string | number}** filename – path to file or a file descriptor. Path can omit the file extension.
- **{object}** object – a content to write to the file
- **{object}** {options = undefined} – writing options
  + **{string}** [options.encoding = "utf8"] – an encoding used to write to the file
  + more options you can find in js-yaml docs in [safeDump](https://github.com/nodeca/js-yaml#safedump-object---options-) section

### `yaml.writeSync(filename, object[, options]) -> {Promise<void>}`

Synchronous version of **yaml.write**
