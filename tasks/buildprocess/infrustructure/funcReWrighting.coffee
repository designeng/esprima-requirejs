fs = require "fs"
_ = require "underscore"
esprima = require "esprima"
escodegen = require "escodegen"    
esmorph = require(__dirname + "/lib/esmorph")

exports.edit = (content, path, infrustructureModules, infrustructureArguments) ->
    # get tree
    AST = esprima.parse content, 
        range: true,
        loc: true,
        tolerant: true

    index = 0
    for obj in AST.body
        if obj.type == "ExpressionStatement" and obj.expression.callee.type == 'Identifier' and obj.expression.callee.name == 'define'

            node = getAloneDefineNode AST.body, index

            # pattern: define( depsArray, func )
            depsArray = node.expression.arguments[0]

            # check if it's realy array of dependedcies, because if it's function ("FunctionExpression") - no dependedcies in current module
            # depsArray also must have elemants
            if depsArray.type is "ArrayExpression" and !_.isEmpty depsArray.elements
                # func {Function}
                # func = node.expression.arguments[1]
                # modules {Array}
                modules = _.map depsArray.elements, (el) -> return el.value
                modules = filterDependencyModules modules, infrustructureModules, infrustructureArguments



            content = escodegen.generate node
            content = "//#{path}\n#{content}"
            return content
        index++

    return content

getAloneDefineNode = (body, index) ->     
    return body[index]

filterDependencyModules = (modules, infModules, infArguments) ->
    # console.log "infModules", infModules
    for mod in modules
        if mod in infModules
            console.log "IN INFRUSTR:", mod



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