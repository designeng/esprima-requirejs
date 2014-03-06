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

            # pattern: define( depsArrayObj, func )
            depsArrayObj = node.expression.arguments[0]

            # modFuncObj {Function} - module's definition function
            modFuncObj = node.expression.arguments[1]

            # check if it's realy array of dependedcies, because if it's function ("FunctionExpression") - no dependedcies in current module
            if depsArrayObj.type is "FunctionExpression" and !modFuncObj
                console.log "DEPSARR:NO............................."
            
            # depsArrayObj also must have elements
            if depsArrayObj.type is "ArrayExpression" and !_.isEmpty depsArrayObj.elements

                # modules {Array}
                modules = _.map depsArrayObj.elements, (el) -> return el.value

                node = filterDependencyModules node, modules, infrustructureModules, infrustructureArguments
                content = escodegen.generate node

            content = "//#{path}\n#{content}"
            return content

        index++

    return content

getAloneDefineNode = (body, index) ->     
    return body[index]

# @return params {Object}
# params type {String}
# params name/value {String} - we are intrested in this
# params range {Object}
# params loc {Object}
removeApropriate = (params, arg, fieldName) ->
    _params = _.filter params, (param) ->
        return param[fieldName] != arg

    return _params

insertInfrustructure = (node) ->

    obj = 
        "type": "Literal"
        "value": "infrustructure"

    node.expression.arguments[0].elements.unshift obj
    return node

insertInfrustructureArgument = (node) ->
    obj = 
        "type": "Identifier"
        "name": "Infrustructure"

    node.expression.arguments[1].params.unshift obj
    return node

insertInfrustructureFields = (node, parentObjectName, params) ->

    for param in params
        obj = 
            "type": "VariableDeclaration"
            "declarations": [
                {
                    "type": "VariableDeclarator"
                    "id": {
                        "type": "Identifier"
                        "name": param.name
                    },
                    "init": {
                        "type": "MemberExpression"
                        "computed": false
                        "object": {
                            "type": "Identifier"
                            "name": parentObjectName
                        }
                        "property": {
                            "type": "Identifier"
                            "name": param.name
                        }
                    }
                }
            ]
            "kind": "var"

        node.expression.arguments[1].body.body.unshift obj

    return node


filterDependencyModules = (node, modules, infModules, infArguments) ->

    inInfrustructure = []

    elements = node.expression.arguments[0].elements
    params   = node.expression.arguments[1].params

    # counter for infrustructure's modules
    k = 0

    for mod in modules
        if mod in infModules

            removedArgumentArr = []

            # remove apropriate element from [dependencies]
            elements = removeApropriate elements, mod, "value"

            # remove apropriate function argument
            _params = removeApropriate params, infArguments[_.indexOf(infModules, mod)], "name"

            # difference
            removedArgumentArr = _.difference params, _params

            if !_.isEmpty removedArgumentArr
                inInfrustructure.push removedArgumentArr[0]
                params = _params

            # increase counter
            k++

    if !_.isEmpty inInfrustructure
        node.expression.arguments[0].elements = elements
        node.expression.arguments[1].params = params

        node = insertInfrustructure node
        node = insertInfrustructureArgument node
        node = insertInfrustructureFields node, "Infrustructure", inInfrustructure

    return node

