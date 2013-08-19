uspec = require('uspec')
describe      = uspec.describe
pending       = uspec.pending
assert        = uspec.assert
assert_throws = uspec.assert_throws
Module = require('module')


describe 'require',

    # CommonJS

    'should be a function': ->
        assert -> require instanceof Function

    'should accept a module identifier': -> pending('how to test that?')

    'should return the exported API of the foreign module': ->
        Module.define 'foo', (exports) -> exports.bar = 'bar'
        assert -> require('foo').bar isnt undefined
        assert -> require('foo').bar == 'bar'

    'should throw an error if the module cannot be returned': ->
        assert_throws Error, -> require 'nonexistent/module'


describe 'Module',

    # CommonJS

    'should have an `export` var, that is an Object': ->
        Module.define 'foo', (exports) ->
            assert -> typeof exports == 'object'

    'should have a `require` var, conformant with the spec': ->
        Module.define 'foo', (exports, require) ->
            assert -> typeof require == 'function'

    'should have a `module` var': ->
        Module.define 'foo', (exports, require, module) ->
            assert -> module instanceof Module
            assert -> module.id == 'foo'

    'should export by adding to the exports var': ->
        m = Module.define 'foo', (exports) -> exports.bar = 'bar'
        assert -> m.exports.bar == 'bar'

    'should have id property': ->
        m = Module.define 'foo', ->
        assert -> m.id isnt undefined

    'should have its id set so that requiring it returns its exports': ->
        m = Module.define 'foo', (exports) -> exports.bar = 'bar'
        assert -> require(m.id) == m.exports

    # Other

    'should define a Module class': ->
        assert -> Module isnt undefined

    'should define a root module': ->
        assert -> Module.root isnt undefined
        assert -> Module.root.id == 'root'


results = uspec.run()
rc = if uspec.summary(results) then 0 else 1

phantom.exit(rc) unless typeof phantom is 'undefined'
process.exit(rc) unless typeof process is 'undefined'
