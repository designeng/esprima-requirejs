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

            # modFunc {Function} - module's definition function
            modFunc = node.expression.arguments[1]
            # and modFunc.type == "FunctionExpression"

            # check if it's realy array of dependedcies, because if it's function ("FunctionExpression") - no dependedcies in current module
            if depsArray.type is "FunctionExpression" and !modFunc
                console.log "DEPSARR:NO"
            
            # depsArray also must have elemants
            if depsArray.type is "ArrayExpression" and !_.isEmpty depsArray.elements

                # modules {Array}
                modules = _.map depsArray.elements, (el) -> return el.value
                modules = filterDependencyModules modules, infrustructureModules, infrustructureArguments
            else 
                console.log "NO-----", depsArray.elements



            content = escodegen.generate node
            content = "//#{path}\n#{content}"
            return content

        index++

    return content

getAloneDefineNode = (body, index) ->     
    return body[index]

filterDependencyModules = (modules, infModules, infArguments) ->
    # console.log "infModules", infModules

    # counter for infrustructure's modules
    k = 0

    for mod in modules
        if mod in infModules
            k++
            console.log "IN INFRUSTR:", mod

