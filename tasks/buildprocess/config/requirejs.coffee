module.exports = (grunt) ->
    grunt.task.registerTask "agent:edit:requirejs:config", "After build we must to rename some params of requirejs configuration and make some changes in index.html.", ->
        fs = require("fs")
        requirejsGruntConfig = grunt.config.getRaw("requirejs")
        mainConfigFile = requirejsGruntConfig.compile.options.mainConfigFile
        appDir = requirejsGruntConfig.compile.options.appDir
        dir = requirejsGruntConfig.compile.options.dir
        baseUrl = requirejsGruntConfig.compile.options.baseUrl
        dstConfigFile = mainConfigFile.replace(appDir, dir)
        resultContent = ""
        targetParam = "baseUrl"

        content = fs.readFileSync("./" + mainConfigFile, "utf-8").toString().split("\n").forEach((line) ->
            line = targetParam + ":\"/" + baseUrl + "\","  unless line.indexOf(targetParam) is -1
            resultContent += line + "\n"
        )
        fs.writeFileSync dstConfigFile, resultContent

        indexContent = fs.readFileSync "./" + dir + "/index.html", "utf-8"
        fs.writeFileSync "./" + dir + "/index.html", indexContent.replace /\/app\//g, "/"