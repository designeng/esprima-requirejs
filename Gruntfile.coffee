funcReWrighting = require __dirname + "/../infrustructure/funcReWrighting"

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

                    onBuildWrite: (moduleName, path, contents) ->
                        contents = funcReWrighting.edit contents, path

                        return contents                                                                                                                                

                    modules: [
                            # name: "main"
                            # include: ["main"]
                            # create: true
                        # ,                                                                                                       
                            name: "withwire"                                                        
                            include: ["../mocha-tests/js/spec/withwire/withwire" ]
                            create: true
                        ]

    grunt.loadNpmTasks "grunt-contrib-requirejs"

    grunt.task.loadTasks __dirname + "/tasks/buildprocess/infrustructure"

    
    grunt.registerTask 'build', ['requirejs']
    grunt.registerTask 'default', ["requirejs", "connect:server", "watch"]