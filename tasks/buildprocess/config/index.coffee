funcReWrighting = require __dirname + "/../infrustructure/funcReWrighting"

module.exports = (grunt) ->
    grunt.task.registerTask "contribRequirejsConfiguration", "Cofiguration of grunt contrib requirejs task", (infrustructure) ->
        console.log "contribRequirejsConfiguration", infrustructure

        # infrustructure is serialized - so needed to be splitted to array:
        infrustructure = infrustructure.split ","
 
        requirejsConfiguration = 
            compile:
                options:                                                                                                        # Look at https://github.com/jfparadis/requirejs-handlebars/blob/master/build.js
                    appDir: "prebuild"
                    baseUrl: "js"
                    mainConfigFile: "prebuild/js/requireConfig.js"
                    dir: "public"
                    inlineText: true

                    # stubModules: ['text', 'hbars'],
                    removeCombined: true
                    preserveLicenseComments: true
                    optimize: "none"
                    uglify:
                        toplevel: true
                        ascii_only: true
                        beautify: false
                        max_line_length: 1000
                        defines:                                                                                                # How to pass uglifyjs defined symbols for AST symbol replacement, see "defines" options for ast_mangle in the uglifys docs.
                            DEBUG: ["name", "false"]
                        no_mangle: true                                                                                         # Custom value supported by r.js but done differently in uglifyjs directly: Skip the processor.ast_mangle() part of the uglify call (r.js 2.0.5+)

                    onBuildWrite: (moduleName, path, contents) ->
                        # whatToChange = ""

                        # res = contents.match(/(?:define\()(.+)(?:function)/)


                        # if path.indexOf("tableController.js") != -1
                        contents = funcReWrighting.edit contents, path

                        return contents
                        
                        # if res
                        #     console.log "=============================================="
                        #     for module in infrustructure
                        #         moduleRegExp = new RegExp("\"" + module + "\"")
                        #         if matches = res[1].match moduleRegExp
                        #             console.log "YES>>>>>", path, module, res[1], matches[0]

                        #             contents = contents.replace matches[0], "\"infrustructure\""
                        #             whatToChange = matches[0]
                        #         else
                        #             console.log "NO:", module, res[1]

                        # return "//BLOCK--------> " + whatToChange + "\n" + contents


                    modules:[
                        {
                            name: "core/appbootstrap"
                            include: ["core/appbootstrap"]
                            exclude: infrustructure
                        },
                        {
                            name: "controls/controls"
                            exclude: infrustructure
                        },
                        {
                            name: "infrustructure"
                            include: infrustructure
                        }
                    ]

        grunt.config.set "requirejs", requirejsConfiguration

