// Generated by CoffeeScript 1.6.3
(function() {
  var Info, dir, expect, info, path;

  expect = require('chai').expect;

  path = require('path');

  Info = require('../../lib/Info');

  dir = path.normalize(__dirname + '/../node_modules');

  info = null;

  describe('Info.fromFile', function() {
    it('should create Info object from main js file', function() {
      info = Info.fromFile(dir + '/simple/index.js');
      return expect(info.getData()).to.be.eql({
        name: 'simple',
        main: './index.js'
      });
    });
    it('should create Info object for advanced module', function() {
      info = Info.fromFile(dir + '/advanced/dir/src/test/test.js');
      return expect(info.getData()).to.be.eql({
        name: 'advanced',
        main: './dir/lib'
      });
    });
    describe('#getMainFile()', function() {
      return it('should get main file for advanced module', function() {
        info = Info.fromFile(dir + '/advanced/dir/src/test/test.js');
        return expect(info.getMainFile()).to.be.equal(dir + '/advanced/dir/lib/index.js');
      });
    });
    return describe('#getPath()', function() {
      return it('should return path to module directory', function() {
        info = Info.fromFile(dir + '/simple/index.js');
        return expect(info.getPath()).to.be.equal(dir + '/simple');
      });
    });
  });

}).call(this);
