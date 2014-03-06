funcReWrighting = require __dirname + "/tasks/buildprocess/infrustructure/funcReWrighting"

infrustructure = [
    "backbone"
    "marionette"
    "underscore"
    "jquery"
    "backbone.wreqr"
    "backbone.babysitter"
]
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
                options:                                                                                                        # Look at https://github.com/jfparadis/requirejs-handlebars/blob/master/build.js
                    appDir: "app"
                    baseUrl: "js"
                    mainConfigFile: "app/js/main.js"
                    dir: "public"

                    removeCombined: true

                    optimize: "none"

                    onBuildRead: (moduleName, path, contents) ->

                        if !relatedPublicBasePath
                            relatedPublicBasePath = grunt.config.get("requirejs.compile.options.dir") + "/" + grunt.config.get("requirejs.compile.options.baseUrl") + "/"

                        # filter all vendor libs
                        if path.indexOf("/vendor/") == -1
                            path = path.split(relatedPublicBasePath)[1]
                            contents = funcReWrighting.edit contents, path

                        return contents                                                                                                                                

                    modules: [
                            name: "infrustructure"                                                       
                            include: infrustructure
                        ,
                            name: "core"
                            include: ["core"]
                            exclude: infrustructure
                        ]

    grunt.loadNpmTasks "grunt-contrib-requirejs"
    grunt.loadNpmTasks "grunt-contrib-connect"
    grunt.loadNpmTasks "grunt-contrib-watch"

    grunt.task.loadTasks __dirname + "/tasks/buildprocess/infrustructure"

    
    grunt.registerTask 'build', ['requirejs']
    grunt.registerTask 'default', ["requirejs", "connect:server", "watch"]