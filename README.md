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

* string file Path to file
* null|string|object Options:
	* encoding String | Null default = null
	* schema More information about this options [here](https://github.com/nodeca/js-yaml#safeload-string---options-).

```coffee
	yaml = require 'node-yaml'

	yaml.read 'path/to/file.yaml', (err, data) ->
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

	data = """
		foo: foo
		bar: bar
	"""

	yaml.write 'path/to/file.yaml', data, (err) -> throw err if err
```

### yaml.writeSync(file, data[, options])

Synchronous version of **yaml.write**. Returns null if file has successfully written.