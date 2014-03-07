_ = require "underscore"

funcReWrighting = require __dirname + "/tasks/buildprocess/infrustructure/funcReWrighting"

# keys - modules Ids, as they defined in requirejs paths
# values - arguments to be specified
infrustructure =
    "backbone" : "Backbone"
    "marionette" : "Marionette"
    "underscore" : "_"
    "jquery" : "$"
    "moment" : "Moment"
    "meld" : "Meld"
    "backbone.wreqr" : "BackboneWreqr"
    "backbone.babysitter" : "BackboneBabysitter"

infrustructureModules = _.keys infrustructure
infrustructureArguments = _.values infrustructure

relatedPublicBasePath = undefined

module.exports = (grunt) ->
  
    # Project configuration.
    grunt.initConfig
        watch:
            js:
                files: ['app/js/**/**.js']
                options:
                    livereload: true

        connect:
            server:
                options:
                    port: 9003
                    base: '.'

        requirejs:
            compile:
                options:                                                                                  
                    appDir: "app"
                    baseUrl: "js"
                    mainConfigFile: "app/js/main.js"
                    dir: "public"

                    removeCombined: true

                    optimize: "none"

                    onBuildRead: (moduleName, path, contents) ->

                        if !relatedPublicBasePath
                            relatedPublicBasePath = grunt.config.get("requirejs.compile.options.dir") + "/" + grunt.config.get("requirejs.compile.options.baseUrl") + "/"

                        # filter
                        if path.indexOf("/vendor/") == -1 and path.indexOf("infrustructure.js") == -1
                            path = path.split(relatedPublicBasePath)[1]
                            contents = funcReWrighting.edit contents, path, infrustructureModules, infrustructureArguments

                        return contents                                                                                                                               

                    modules: [
                            name: "infrustructure"                                                       
                            include: infrustructureModules
                        ,
                            name: "core"
                            include: ["core"]
                            exclude: _.flatten [infrustructureModules, "infrustructure"]
                        ]

    grunt.loadNpmTasks "grunt-contrib-requirejs"
    grunt.loadNpmTasks "grunt-contrib-connect"
    grunt.loadNpmTasks "grunt-contrib-watch"

    # loading...
    # 1) grunt task createInfrustructure
    # 2) module funcReWrighting
    grunt.task.loadTasks __dirname + "/tasks/buildprocess/infrustructure"

    
    grunt.registerTask 'build', ['requirejs']

    # task for creating "infrustructure.js" module with infrustructure dependencies and Infrustructure object return
    grunt.registerTask 'inf', ['createInfrustructure:' + infrustructureModules + ":" + infrustructureArguments + ":" + "app/js"]

    # requirejs build task with server and watch
    grunt.registerTask 'default', ["requirejs", "connect:server", "watch"]