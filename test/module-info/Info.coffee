expect = require('chai').expect
path = require 'path'

Info = require '../../lib/Info'

dir = path.normalize(__dirname + '/../data/test/node_modules')
info = null

describe 'Info', ->

	describe '#constructor()', ->
		it 'should throw an error if directory does not exists', ->
			expect( -> new Info('unknown/directory') ).to.throw(Error)

		it 'should throw an error if path is not directory', ->
			expect( -> new Info('./Info.coffee') ).to.throw(Error)

		it 'should throw an error if package.json does not exists', ->
			expect( -> new Info('../node_modules') ).to.throw(Error)

	describe '#getPackagePath()', ->
		it 'should return path to package.json file', ->
			info = new Info(dir + '/simple')
			expect(info.getPackagePath()).to.be.equal(dir + '/simple/package.json')

	describe '#getData()', ->
		it 'should return json data from package.json file', ->
			info = new Info(dir + '/simple')
			expect(info.getData()).to.be.eql(
				name: 'simple'
				main: './index.js'
			)

	describe '#getName()', ->
		it 'should return name of module', ->
			info = new Info(dir + '/simple')
			expect(info.getName()).to.be.equal('simple')

	describe '#getPath()', ->
		it 'should return path to module directory', ->
			info = new Info(dir + '/simple')
			expect(info.getPath()).to.be.equal(dir + '/simple')

	describe '#getMainFile()', ->
		it 'should return path to main file', ->
			info = new Info(dir + '/simple')
			expect(info.getMainFile()).to.be.equal(dir + '/simple/index.js')

		it 'should return path to main file when it is not defined in package.json', ->
			info = new Info(dir + '/no-main')
			expect(info.getMainFile()).to.be.equal(dir + '/no-main/index.js')

		it 'should return null when main file is not defined and index.js does not exists', ->
			info = new Info(dir + '/no-main2')
			expect(info.getMainFile()).to.be.null

	describe '#getModuleName()', ->
		it 'should throw an error if file is not placed in module', ->
			info = new Info(dir + '/simple')
			expect( -> info.getModuleName(dir + '/no-main/index.js')).to.throw(Error, 'File ' + dir + '/no-main/index.js is not in simple module.')

		it 'should throw an error if file does not exists', ->
			info = new Info(dir + '/simple')
			expect( -> info.getModuleName('unknown') ).to.throw(Error)

		it 'should throw an error if path is not file', ->
			info = new Info(dir + '/simple')
			expect( -> info.getModuleName(dir + '/simple') ).to.throw(Error)

		it 'should get name of module itself', ->
			info = new Info(dir + '/simple')
			expect(info.getModuleName('index.js')).to.be.equal('simple')

			info = new Info(dir + '/advanced')
			expect(info.getModuleName('dir/lib/index.js')).to.be.equal('advanced')

		it 'should get name of file in module for require method', ->
			info = new Info(dir + '/advanced')
			expect(info.getModuleName('dir/src/test/test.js')).to.be.equal('advanced/dir/src/test/test.js')

		it 'should get name of file in module for absolute path', ->
			info = new Info(dir + '/advanced')
			expect(info.getModuleName(dir + '/advanced/dir/src/test/test.js')).to.be.equal('advanced/dir/src/test/test.js')

	describe '#isNpmDependency()', ->
		it 'should return true', ->
			info = new Info(dir + '/simple')
			expect(info.isNpmDependency()).to.be.true

		it 'should return false', ->
			info = new Info(path.resolve(dir + '/..'))
			expect(info.isNpmDependency()).to.be.false

	describe '#isFileInModule()', ->
		it 'should return true for non npm module file', ->
			info = new Info(path.resolve(dir + '/..'))
			expect(info.isFileInModule('./application.js')).to.be.true

		it 'should return false for file in npm module called from non npm module', ->
			info = new Info(path.resolve(dir + '/..'))
			expect(info.isFileInModule('./node_modules/simple/index.js')).to.be.false

		it 'should return true for file from npm module', ->
			info = new Info(dir + '/simple')
			expect(info.isFileInModule('./index.js')).to.be.true

		it 'should return false for file in submodule of npm module', ->
			info = new Info(dir + '/advanced')
			expect(info.isFileInModule('./node_modules/another/index.js')).to.be.false