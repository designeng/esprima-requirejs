define([
    "backbone",
    "marionette",
    "globalEvents",
    "tableView"
], function (Backbone, Marionette, globalEvents, tableView){
    var start = function (opt){
        console.log(opt)
    }
    var core = {
        start: start
    }
    return core;
});