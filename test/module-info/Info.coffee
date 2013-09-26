expect = require('chai').expect
path = require 'path'

Info = require '../../lib/Info'

dir = path.normalize(__dirname + '/../node_modules')
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

	describe '#getPackageData()', ->
		it 'should return json data from package.json file', ->
			info = new Info(dir + '/simple')
			expect(info.getPackageData()).to.be.eql(
				name: 'simple'
				main: './index.js'
			)

	describe '#getName()', ->
		it 'should return name of module', ->
			info = new Info(dir + '/simple')
			expect(info.getName()).to.be.equal('simple')

	describe '#getMainFile()', ->
		it 'should return path to main file', ->
			info = new Info(dir + '/simple')
			expect(info.getMainFile()).to.be.equal(dir + '/simple/index.js')

		it 'should return path to main file when it is not defined in package.json', ->
			info = new Info(dir + '/no-main')
			expect(info.getMainFile()).to.be.equal(dir + '/no-main/index.js')