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

## API

### `yaml.read(filename[, options]) -> {Promise<object>}`

Read and parse YAML file from given path. Takes following arguments:

- **{string | number}** filename – path to file or a file descriptor
- **{object}** {options = undefined} – reading options
  + **{string}** options.encoding – an encoding used to read the file
  + more options you can find in js-yaml docs in [safeLoad](https://github.com/nodeca/js-yaml#safeload-string---options-) section

### `yaml.readSync(filename[, options]) -> {object}`

Synchronous version of **yaml.read**

### `yaml.write(filename, object[, options]) -> {void}`

Write given YAML content to disk. Takes following arguments:

- **{string | number}** filename – path to file or a file descriptor
- **{object}** object – a content to write to the file
- **{object}** {options = undefined} – writing options
  + **{string}** options.encoding – an encoding used to write to the file
  + more options you can find in js-yaml docs in [safeLoad](https://github.com/nodeca/js-yaml#safeload-string---options-) section

### `yaml.writeSync(filename, object[, options]) -> {Promise<void>}`

Synchronous version of **yaml.write**
