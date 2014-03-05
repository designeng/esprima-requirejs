define([
    "marionette"
], function (Marionette){
    var BaseLayout;
    BaseLayout = Marionette.Layout.extend({
        initialize: function(options){
            console.log("baseLayout inited");
        }
    });
    return BaseLayout;
});