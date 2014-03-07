fs = require "fs"
_ = require "underscore"
esprima = require "esprima"
escodegen = require "escodegen"

insertDependencies = (node, dependency) ->
    for dep in dependency
        obj = 
            "type": "Literal"
            "value": dep

        node.expression.arguments[0].elements.unshift obj
    return node

insertArguments = (node, args) ->
    for arg in args
        obj = 
            "type": "Identifier"
            "name": arg

        node.expression.arguments[1].params.unshift obj
    return node

insertInfrustructureFields = (node, parentObjectName, params) ->

    obj =
        "type": "ReturnStatement"
        "argument":
            "type": "Identifier"
            "name": "Infrustructure"
    node.expression.arguments[1].body.body.unshift obj

    for param in params
        obj = 
            "type": "ExpressionStatement"
            "expression":
                "type": "AssignmentExpression"
                "operator": "="
                "left":
                    "type": "MemberExpression"
                    "computed": false
                    "object":
                        "type": "Identifier"
                        "name": parentObjectName
                    "property":
                        "type": "Identifier"
                        "name": param
                "right":
                    "type": "Identifier"
                    "name": param
        node.expression.arguments[1].body.body.unshift obj

    obj =
        "type": "VariableDeclaration"
        "declarations": [
            {
                "type": "VariableDeclarator"
                "id": {
                    "type": "Identifier"
                    "name": parentObjectName
                }
                "init": {
                    "type": "ObjectExpression"
                    "properties": []
                }
            }
        ]
        "kind": "var"
    node.expression.arguments[1].body.body.unshift obj


    return node

module.exports = (grunt) ->

    grunt.task.registerTask "createInfrustructure", "create infrustructure.js with dependencies", (infrustructureModules, infrustructureArguments, dir) ->

        infrustructureModules = infrustructureModules.split ","
        infrustructureArguments = infrustructureArguments.split ","

        tplContent = fs.readFileSync(__dirname + '/tpl/infrustructure.js.tpl', "utf-8")

        # get tree
        AST = esprima.parse tplContent, 
            range: true,
            loc: true,
            tolerant: true

        # garanteed "define" function at the 0 array position
        node = AST.body[0]    

        node = insertDependencies node, infrustructureModules
        node = insertArguments node, infrustructureArguments
        node = insertInfrustructureFields node, "Infrustructure", infrustructureArguments

        content = escodegen.generate node

        fs.writeFileSync "./#{dir}/infrustructure.js", content