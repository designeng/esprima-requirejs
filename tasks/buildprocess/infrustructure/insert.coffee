module.exports = (grunt) ->

    fs = require "fs"
    _ = require "underscore"
    esprima = require "esprima"
    escodegen = require "escodegen"    
    esmorph = require(__dirname + "/lib/esmorph")

    grunt.task.registerTask "esprimaInsert", "esprimaInsert", () ->

        filepath = "./public/js/controls/dropdownlist/dropDownListControl.js"

        content = fs.readFileSync(filepath, "utf-8")

        AST = esprima.parse content, 
            range: true,
            loc: true,
            tolerant: true

        console.log "AST 1", AST.body[0].expression.callee.object.body.body[0].expression.arguments[0].elements
        console.log "============"
        console.log "AST 2", AST.body[0].expression.callee.object.body.body[0].expression.arguments[1].params

        functionList = esmorph.collectFunction content, AST

        # console.log functionList[0].node.body.body[0].declarations
        # console.log functionList[0].node

        mainDefinedFunc = functionList[0].node

        # here we can change params array:
        mainDefinedFunc.params = []