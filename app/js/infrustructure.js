define([
    'backbone.babysitter',
    'backbone.wreqr',
    'meld',
    'moment',
    'jquery',
    'underscore',
    'marionette',
    'backbone'
], function (BackboneBabysitter, BackboneWreqr, Meld, Moment, $, _, Marionette, Backbone) {
    var Infrustructure = {};
    Infrustructure.BackboneBabysitter = BackboneBabysitter;
    Infrustructure.BackboneWreqr = BackboneWreqr;
    Infrustructure.Meld = Meld;
    Infrustructure.Moment = Moment;
    Infrustructure.$ = $;
    Infrustructure._ = _;
    Infrustructure.Marionette = Marionette;
    Infrustructure.Backbone = Backbone;
    return Infrustructure;
});