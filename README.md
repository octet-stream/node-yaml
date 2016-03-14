# Node YAML

A wrapper for [js-yaml](https://github.com/nodeca/js-yaml) parser

## Installation

You can install this module using NPM:

```bash
  npm install --save node-yaml
```

## API

### yaml.read(file[, options], callback)

Read and parse YAML file.

* file Path to file or file descriptor
* null|string|object Options:
  * [string] encoding (default = utf8)
  * [object] schema - specifies a schema to use. More information about this option [here](https://github.com/nodeca/js-yaml#safeload-string---options-) (default - defaultSafe).
    * defaultSafe - all supported YAML types, without unsafe ones
    * defaultFull - all supported YAML types
    * failsafe - only strings, arrays and plain objects
    * json - all JSON-supported types
    * core - same as json schema

```coffee
  yaml = require 'node-yaml'

  yaml.read 'path/to/file.yaml',
    encoding: 'utf8'
    schema: yaml.schema.defaultSafe,
    (err, data) ->
      if err
        throw err
      console.log data
```

**Note**: You also can use path without file extension (only for yaml.read and yaml.readSync).

**Note**: yaml.schema.defaultSafe schema used by default because is that recomended loading way.

### yaml.readPromise(file[, options])

This method return an instance of **Promise**.

```coffee
  {readPromise} = require 'node-yaml'

  readPromise 'path/to/file.yaml'
    .then (data) -> console.log data
```

### yaml.readSync(file[, options])

Synchronous version of **yaml.read**. Return the contents of the **file**

### yaml.write(file, data[, options], callback)

Parse and write YAML to file.

```coffee
  {write} = require 'node-yaml'

  data =
    "foo": "foo"
    "bar": "bar"

  write 'path/to/file.yaml', data, 'utf8', (err) -> throw err if err
```

### yaml.writePromise(file, data[, options])

```coffee
  {writePromise} = require 'node-yaml'

  data =
    "foo": "foo"
    "bar": "bar"

  writePromise 'path/to/file.yaml', data
    .then ->
      # Do something.
    .catch (err) ->
      # I just don't know what went wrong.
```

### yaml.writeSync(file, data[, options])

Synchronous version of **yaml.write**. Returns null if file has successfully written.

### yaml.parse(string[, options])

Parse YAML.

* string - YAML string to parse
* [object] options:
  * [object] schema

```coffee
  {parse} = require 'node-yaml'

  data = """
    foo: foo
    bar: bar
  """

  console.log parse data
```

### yaml.dump(json[, options])

Convert JSON into YAML.

```coffee
  {dump} = require 'node-yaml'

  data =
    "foo": "foo"
    "bar": "bar"

  console.log dump data
```