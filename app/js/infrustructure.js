define([
    "backbone",
    "marionette",
    "jquery",
    "underscore",
    "meld",
    "moment"
], function(Backbone, Marionette, $, _, Meld, Moment) {
    var infrustructure = {
      Backbone: Backbone,
      Marionette: Marionette,
      $: $,
      _: _,
      Moment: Moment,
      Meld: Meld
    };
    return infrustructure
});