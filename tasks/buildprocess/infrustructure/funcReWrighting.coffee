fs = require "fs"
_ = require "underscore"
esprima = require "esprima"
escodegen = require "escodegen"    
esmorph = require(__dirname + "/lib/esmorph")

exports.edit = (content, path) ->
    # get tree
    AST = esprima.parse content, 
        range: true,
        loc: true,
        tolerant: true

    index = 0
    for obj in AST.body
        if obj.type == "ExpressionStatement" and obj.expression.callee.type == 'Identifier' and obj.expression.callee.name == 'define'

            content = getAloneDefineStatement content, AST.body, index

            content = "//" + path + "\n#{content}"

            return content
        index++

    return content

getAloneDefineStatement = (content, body, index) ->
    defineFunctionNode = body[index]
    content = escodegen.generate defineFunctionNode

    return content


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