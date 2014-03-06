// infrustructure libs at random ("backbone", "marionette", "jquery")
define([
    "backbone",  
    "globalEvents",
    "marionette", 
    "tableView",
    "meld",
    "moment",
    "jquery"
],function (Backbone, GlobalEvents, Marionette, TableView, Meld, Moment, $){
    var start = function (opt){
        console.log(opt)
    }
    var core = {
        start: start
    }
    return core;
});