fs = require "fs"
_ = require "underscore"
esprima = require "esprima"
escodegen = require "escodegen"    
esmorph = require(__dirname + "/lib/esmorph")

exports.edit = (content, path) ->

    i = 0

    console.log "PATH >>>>>>>>>>>>>>>>>>>>>", path

    AST = esprima.parse content, 
        range: true,
        loc: true,
        tolerant: true

    for obj in AST.body
        console.log("OBJ:::" + i, obj)
        i++
        if !obj.expression or !obj.expression.callee

            return content

        else if obj.type == "ExpressionStatement"
            if obj.expression.callee.type == 'Identifier' and obj.expression.callee.name == 'define'

                startPos = obj.expression.range[0]
                endPos = obj.expression.range[1]

                console.log "PATH ===========", path

                content = content.substring startPos, endPos

    return content

    # if AST.body[0].expression.callee.object.body.body[0].expression
    #     console.log "============"
    #     console.log "AST 1", AST.body[0].expression.callee.object.body.body[0].expression.arguments[0].elements

    # # if AST.body[0].expression and AST.body[0].expression.callee and AST.body[0].expression.callee.object and AST.body[0].expression.callee.object.body and 
    # if AST.body[0].expression.callee.object.body.body[0].expression.arguments[1]
    #     console.log "------------"
    #     console.log "AST 2", AST.body[0].expression.callee.object.body.body[0].expression.arguments[1].params

    # return content

exports.insert = (filepath) ->

    filepath = "./app/js/controls/dropdownlist/dropDownListControl.js"

    content = fs.readFileSync(filepath, "utf-8")

    AST = esprima.parse content, 
        range: true,
        loc: true,
        tolerant: true

    console.log "AST 1", AST.body[0].expression.callee.object.body.body[0].expression.arguments[0].elements
    console.log "============"
    console.log "AST 2", AST.body[0].expression.callee.object.body.body[0].expression.arguments[1].params

    return

    functionList = esmorph.collectFunction content, AST

    mainDefinedFunc = functionList[0].node

    console.log mainDefinedFunc.params

    # here we can change params array:
    mainDefinedFunc.params = []

    # console.log escodegen.generate mainDefinedFunc