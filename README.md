# Node YAML

A wrapper for js-yaml parser

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
	* encoding String | Null default = null
	* [string] schema - specifies a schema to use. More information about this option [here](https://github.com/nodeca/js-yaml#safeload-string---options-).
		* defaultSafe - all supported YAML types, without unsafe ones
		* defaultFull - all supported YAML types
		* failsafe - only strings, arrays and plain objects
		* json - all JSON-supported types
		* core - same as JSON_SCHEMA

```coffee
	yaml = require 'node-yaml'

	yaml.read 'path/to/file.yaml', encoding: 'utf8', schema: 'defaultSafe', (err, data) ->
		if err
			throw err
		console.log data
```

**Note:** You also can use path without file extension (only for yaml.read and yaml.readSync).

### yaml.readSync(file[, options])

Synchronous version of **yaml.read**. Returns the contents of the **file**

### yaml.write(file, data[, options], callback)

Parse and write YAML to file.

```coffee
	yaml = require 'node-yaml'

	data =
		"foo": "foo"
		"bar": "bar"

	yaml.write 'path/to/file.yaml', data, (err) -> throw err if err
```

### yaml.writeSync(file, data[, options])

Synchronous version of **yaml.write**. Returns null if file has successfully written.

### yaml.parse(string[, options])

Parse YAML.

* string - YAML string to parse
* options:
	* [string] schema

```coffee
	yaml = require 'node-yaml'

	data = """
		foo: foo
		bar: bar
	"""

	console.log yaml.parse data
```

### yaml.dump(json[, options])

Convert JSON into YAML.

```coffee
	yaml = require 'node-yaml'

	data =
		"foo": "foo"
		"bar": "bar"

	console.log yaml.dump data
```