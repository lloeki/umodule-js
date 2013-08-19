###
# umodule.js v0.5
# (c) 2013 Loic Nageleisen
# Licensed under 3-clause BSD
###

root = global ? window


require = (id) ->
    target = Module.root
    target = target[item] for item in id.split('/')
    throw new Error("module not found: #{id}") if typeof target is 'undefined'
    target.exports


class Module
    constructor: (@id) ->
        @exports = {}

    @define: (target, name, block) ->
        if arguments.length < 3
            [target, name, block] = [Module.root, arguments...]

        top    = target
        target = target[item] or= new Module(item) for item in name.split '/'
        block.call(target, target.exports, target.require, target)

        target

    require: -> require()


Module.root = new Module('root')
Module.root.exports = root
Module.root.module = new Module('module')
Module.root.module.exports = Module

root.require = require
