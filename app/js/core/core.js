// infrustructure libs at random ("backbone", "marionette", "jquery")
define([
    "backbone",  
    "globalEvents",
    "marionette", 
    "tableView",
    "meld",
    "moment",
    "jquery",
    "oneModule"
],function (Backbone, GlobalEvents, Marionette, TableView, Meld, Moment, $, oneModule){
    var start = function (opt){
        console.log(opt)
    }
    var core = {
        start: start
    }
    return core;
});