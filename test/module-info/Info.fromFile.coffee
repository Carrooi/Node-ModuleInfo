expect = require('chai').expect
path = require 'path'

Info = require '../../lib/Info'

dir = path.normalize(__dirname + '/../data/test/node_modules')
info = null

describe 'Info.fromFile', ->

	it 'should create Info object from main js file', ->
		info = Info.fromFile(dir + '/simple/index.js')
		expect(info.getData()).to.be.eql(
			name: 'simple'
			main: './index.js'
		)

	it 'should create Info object for advanced module', ->
		info = Info.fromFile(dir + '/advanced/dir/src/test/test.js')
		expect(info.getData()).to.be.eql(
			name: 'advanced'
			main: './dir/lib'
		)

	describe '#getMainFile()', ->
		it 'should get main file for advanced module', ->
			info = Info.fromFile(dir + '/advanced/dir/src/test/test.js')
			expect(info.getMainFile()).to.be.equal(dir + '/advanced/dir/lib/index.js')

	describe '#getPath()', ->
		it 'should return path to module directory', ->
			info = Info.fromFile(dir + '/simple/index.js')
			expect(info.getPath()).to.be.equal(dir + '/simple')