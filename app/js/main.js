require.config({
    baseUrl: "/app/js",
    paths:{
        // infrustructure
        "backbone" : "vendor/backbone",
        "marionette" : "vendor/backbone.marionette",
        "underscore" : "vendor/underscore",
        "jquery" : "vendor/jquery.min",

        // core
        "core" : "core/core",
        "globalEvents" : "core/globalEvents",
        "tableView" : "core/tableView"
    }
});

require(["infrustructure", "core"], function (core){
    core.start()
})