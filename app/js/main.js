require.config({
    baseUrl: "/app/js",
    paths:{
        // infrustructure
        "backbone" : "vendor/backbone",
        "marionette" : "vendor/backbone.marionette",
        "underscore" : "vendor/underscore",
        "jquery" : "vendor/jquery.min",
        "backbone.wreqr" : "vendor/backbone.wreqr",
        "meld"  : "vendor/meld",
        "backbone.babysitter" : "vendor/backbone.babysitter",
        "moment"  : "vendor/moment",        

        // core
        "core" : "core/core",
        "baseLayout": "core/layout/baseLayout",
        "globalEvents" : "core/globalEvents",
        "tableView" : "core/tableView",
        "oneModule" : "core/one/oneModule"
    },
    shim:{
        marionette: ["backbone"],
        backbone: {
          deps: ["underscore", "jquery"],
          exports: "Backbone"
        },
        "backbone.wreqr": {
          deps: ["backbone"]
        },
        "backbone.babysitter": {
          deps: ["backbone"]
        }
    }
});

require(["core", "infrustructure"], function (core){
    core.start("test");
})