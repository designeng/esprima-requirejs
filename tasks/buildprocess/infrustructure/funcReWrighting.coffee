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
            # and modFuncObj.type == "FunctionExpression"

            # check if it's realy array of dependedcies, because if it's function ("FunctionExpression") - no dependedcies in current module
            if depsArrayObj.type is "FunctionExpression" and !modFuncObj
                console.log "DEPSARR:NO"
            
            # depsArrayObj also must have elemants
            if depsArrayObj.type is "ArrayExpression" and !_.isEmpty depsArrayObj.elements

                # modules {Array}
                modules = _.map depsArrayObj.elements, (el) -> return el.value

                node = filterDependencyModules node, depsArrayObj, modFuncObj, modules, infrustructureModules, infrustructureArguments
                content = escodegen.generate node
            else 
                console.log "NO-----"

            content = "//#{path}\n#{content}"
            return content

        index++

    return content

getAloneDefineNode = (body, index) ->     
    return body[index]

# @return params {Object}
# params type {String}
# params name {String} - we are intrested in this
# params range {Object}
# params loc {Object}
removeApropriateFuncArgument = (params, arg) ->
    params = _.filter params, (param) ->
        return param.name != arg

    return params

removeApropriateElement = (elements, dep) ->
    elements = _.filter elements, (el) ->
        return el.value != dep

    return elements

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


filterDependencyModules = (node, depsArrayObj, modFuncObj, modules, infModules, infArguments) ->

    inInfrustructure = []

    elements = depsArrayObj.elements
    params = modFuncObj.params

    # counter for infrustructure's modules
    k = 0

    for mod in modules
        if mod in infModules
            # remove element from [dependencies]
            elements = removeApropriateElement elements, infModules[k]
            # remove apropriate function argument
            _params = removeApropriateFuncArgument params, infArguments[k]
            # removeApropriateFuncArgument modFuncObj.params, infArguments[k]

            # difference
            removedArgumentArr = _.difference params, _params
            if !_.isEmpty removedArgumentArr
                inInfrustructure.push removedArgumentArr[0]
                params = _params

            k++

            console.log "IN INFRUSTR:", mod
            console.log "elements", elements
            console.log "params", params


    console.log "inInfrustructure>>>>>>>>>>>", inInfrustructure

    node.expression.arguments[0].elements = elements
    node.expression.arguments[1].params = params

    node = insertInfrustructure node
    node = insertInfrustructureArgument node
    node = insertInfrustructureFields node, "Infrustructure", inInfrustructure

    return node

