path = require 'path'
fs = require 'fs'
Finder = require 'fs-finder'

class Info


	dir: null

	packageData: null


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
		directories = Finder.in(path.dirname(pmodule.filename)).lookUp().findDirectories('node_modules')
		m = null
		for dir in directories
			if fs.existsSync(dir + '/' + name) && fs.statSync(dir + '/' + name).isDirectory()
				m = dir + '/' + name
				break

		if m == null
			throw new Error 'Module ' + name + ' was not found.'

		return new Info(m)


	@self: (pmodule) ->
		pckg = Finder.in(path.dirname(pmodule.filename)).lookUp().findFiles('package.json')
		if pckg == null
			throw new Error 'File ' + pmodule.filename + ' is not in module.'

		return new Info(path.dirname(pckg))


	getPackagePath: ->
		return @dir + '/package.json'


	getPackageData: ->
		if @packageData == null
			info = JSON.parse(fs.readFileSync(@getPackagePath(), encoding: 'utf8'))
			if typeof info.main == 'undefined' then info.main = './index'

			@packageData = info

		return @packageData


	getName: ->
		return @getPackageData().name


	getPath: ->
		return @dir


	getModuleName: (file) ->
		file = path.resolve(@dir, file)
		if !fs.existsSync(file)
			throw new Error 'File ' + file + ' does not exists.'

		if !fs.statSync(file).isFile()
			throw new Error 'Path ' + file + ' is not file.'

		if file == @getMainFile()
			return @getName()

		return @getName() + '/' + path.relative(@dir, file)


	getVersion: ->
		return @getPackageData().version


	getMainFile: ->
		return require.resolve(@dir + '/' + @getPackageData().main)


module.exports = Info