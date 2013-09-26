expect = require('chai').expect
path = require 'path'

Info = require '../../lib/Info'

dir = path.normalize(__dirname + '/../node_modules')
info = null

describe 'Info.fromFile', ->

	it 'should create Info object from main js file', ->
		info = Info.fromFile(dir + '/simple/index.js')
		expect(info.getPackageData()).to.be.eql(
			name: 'simple'
			main: './index.js'
		)

	it 'should create Info object for advanced module', ->
		info = Info.fromFile(dir + '/advanced/dir/src/test/test.js')
		expect(info.getPackageData()).to.be.eql(
			name: 'advanced'
			main: './dir/lib'
		)

	describe '#getMainFile()', ->
		it 'should get main file for advanced module', ->
			info = Info.fromFile(dir + '/advanced/dir/src/test/test.js')
			expect(info.getMainFile()).to.be.equal(dir + '/advanced/dir/lib/index.js')