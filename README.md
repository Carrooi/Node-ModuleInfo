# module-info

Find package.json files in module and load information from it.

## Installation

```
$ npm install module-info
```

## Usage

Base option is to set base directory of module.

```
var Info = require('module-info');
var info = new Info('/path/to/some/module');
```

### Find from file in module

If you have got some file somewhere in module directory tree, module-info can find information about module automatically.

```
var info = Info.fromFile('/path/to/some/module/and/some/file/in/it.js');
```

### Find by name (in node_modules)

You can search for information about some module on which your module is dependent.

```
var info = Info.fromName(module, 'dependent-module');
```

### Find for your module

This option is similar for example to package [pkginfo](https://npmjs.org/package/pkginfo).

```
var info = Info.self(module);
```

## Info object

* `getPackagePath()`: returns path to `package.json` file
* `getData()`: returns parsed JSON data from `package.json` file
* `getName()`: returns name of module
* `getPath()`: returns resolved path to module
* `getVersion()`: returns version of module
* `getMainFile()`: returns resolved full path to main file (even it is not defined in `package.json`)
* `getModuleName(string filePath, bool relative = false)`: returns name for file in module used in `require` method
* `isNpmDependency()`: return true if module is dependency for another module
* `isFileInModule(string filePath)`: checks if file is in module directory (not in any dependent sub-module)

## Tests

```
$ npm test
```

## Changelog

* 1.2.2
	+ Bug with giving name of some files

* 1.2.1
	+ `getModuleName` can return name relatively to base module directory

* 1.2.0
	+ Added method `isNpmDependency`
	+ Added method `isFileInModule`
	+ Method `getModuleName` throw an error if file is not in module
	+ Some refactoring in tests

* 1.1.2
	+ Just typo in readme

* 1.1.11
	+ If main section in package.json is not defined and file `./index.js` exists, it will be returned from `getMainFile` method
	+ Method `getPackageData` renamed to `getData`
	+ Method `getPackageData` is now deprecated

* 1.1.0
	+ Added getPath method
	+ Added getModuleName method

* 1.0.0
	+ First version