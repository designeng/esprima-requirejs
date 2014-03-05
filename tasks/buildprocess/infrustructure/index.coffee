module.exports = (grunt) ->

    fs = require "fs"
    _ = require "underscore"

    grunt.task.registerTask "createInfrustructure", "create infrustructure.js with dependencies", (infrustructure, dir) ->

        tplContent = fs.readFileSync(__dirname + '/tpl/infrustructure.js.tpl', "utf-8")

        # infrustructureAsString = infrustructure

        infrustructure = infrustructure.split ","

        infrustructure = _.map infrustructure, (element) ->
            return "\"#{element}\""

        infrustructure[0] = "[" + _.first(infrustructure)
        infrustructure[infrustructure.length - 1] = _.last(infrustructure) + "]"

        infrustructure = infrustructure.join ", "

        console.log "JOINED:", infrustructure

        obj = 
            infrustructure: infrustructure
            # infrustructureAsString: infrustructureAsString

        content = grunt.template.process tplContent, {data: obj}

        fs.writeFileSync "./#{dir}/infrustructure.js", content