expect = require('chai').expect
path = require 'path'

Info = require '../../lib/Info'

dir = path.normalize(__dirname + '/../node_modules')
info = null

describe 'Info.self', ->

	describe '#getMainFile()', ->
		it 'should get main file for advanced module', ->
			info = Info.self(module)
			main = info.getMainFile()
			expect(main).to.be.equal(path.normalize(__dirname + '/../../lib/Info.js'))