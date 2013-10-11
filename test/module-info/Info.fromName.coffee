expect = require('chai').expect
path = require 'path'

Info = require '../../lib/Info'

dir = __dirname
info = null

describe 'Info.fromName', ->

	it 'should create Info object from module name', ->
		info = Info.fromName module, 'simple'
		expect(info.getData()).to.be.eql(
			name: 'simple'
			main: './index.js'
		)

	it 'should create Info object for advanced module', ->
		info = Info.fromName module, 'advanced'
		expect(info.getData()).to.be.eql(
			name: 'advanced'
			main: './dir/lib'
		)

	describe '#getMainFile()', ->
		it 'should get main file for advanced module', ->
			info = Info.fromName module, 'advanced'
			expect(info.getMainFile()).to.be.equal(dir + '/node_modules/advanced/dir/lib/index.js')