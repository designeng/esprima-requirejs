define([
    "backbone", 
    "marionette", 
    "globalEvents", 
    "jquery", 
    "tableView"
],function (Backbone, Marionette, GlobalEvents, $, TableView){
    var start = function (opt){
        console.log(opt)
    }
    var core = {
        start: start
    }
    return core;
});