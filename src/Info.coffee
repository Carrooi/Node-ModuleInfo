path = require 'path'
fs = require 'fs'
Finder = require 'fs-finder'
escapeRegexp = require 'escape-regexp'

class Info


	dir: null

	data: null


	constructor: (@dir) ->
		@dir = path.resolve(@dir)

		if !fs.existsSync(@dir)
			throw new Error 'Directory ' + @dir + ' does not exists.'

		if !fs.statSync(@dir).isDirectory()
			throw new Error 'Path ' + @dir + ' is not directory.'

		if !fs.existsSync(@dir + '/package.json') || !fs.statSync(@dir + '/package.json').isFile()
			throw new Error 'package.json file was not found.'


	@fromFile: (file) ->
		pckg = Finder.in(path.dirname(file)).lookUp().findFirst().findFiles('package.json')

		if pckg == null
			throw new Error 'File ' + file + ' is not in node module.'

		dir = path.dirname(pckg)

		return new Info(dir)


	@fromName: (pmodule, name) ->
		for dir in pmodule.paths
			m = dir + '/' + name
			if fs.existsSync(m) && fs.statSync(m).isDirectory()
				return new Info(m)

		throw new Error 'Module ' + name + ' was not found.'


	@self: (pmodule) ->
		pckg = Finder.in(path.dirname(pmodule.filename)).lookUp().findFiles('package.json')
		if pckg == null
			throw new Error 'File ' + pmodule.filename + ' is not in module.'

		return new Info(path.dirname(pckg))


	getPackagePath: ->
		return @dir + '/package.json'


	getData: ->
		if @data == null
			info = JSON.parse(fs.readFileSync(@getPackagePath(), encoding: 'utf8'))

			if typeof info.main == 'undefined'
				if fs.existsSync(@dir + '/index.js')
					info.main = './index.js'
				else
					info.main = null

			@data = info

		return @data


	# deprecated
	getPackageData: ->
		return @getData()


	getName: ->
		return @getData().name


	getPath: ->
		return @dir


	getModuleName: (file, relative = false) ->
		file = path.resolve(@dir, file)

		if !@isFileInModule(file)
			throw new Error 'File ' + file + ' is not in ' + @getName() + ' module.'

		if !fs.existsSync(file)
			throw new Error 'File ' + file + ' does not exists.'

		if !fs.statSync(file).isFile()
			throw new Error 'Path ' + file + ' is not file.'

		if file == @getMainFile() && !relative
			return @getName()

		_path = path.relative(@dir, file)
		return if relative then _path else @getName() + '/' + _path


	getVersion: ->
		return @getData().version


	getMainFile: ->
		main = @getData().main
		if main == null
			return null
		else
			return require.resolve(@dir + '/' + main)


	isNpmDependency: ->
		test = escapeRegexp('/node_modules/' + @getName())
		return @dir.match(new RegExp(test)) != null


	isFileInModule: (file) ->
		file = path.resolve(@dir, file)
		if @isNpmDependency()
			dir = escapeRegexp(@dir)
			match = file.match(new RegExp('^' + dir + '\/(.*)$'))
			if match == null
				return false

			if match[1].match(/node_modules/) == null
				return true
		else
			if file.match(/node_modules/) != null
				return false

			dir = escapeRegexp(@dir)
			if file.match(new RegExp('^' + dir)) != null
				return true

		return false


module.exports = Info
