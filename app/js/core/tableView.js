var __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

define('page1',["backbone", "marionette", "baseLayout"], function(Backbone, Marionette, BaseLayout) {
  var TableBodyRegionType, TableHeaderRegionType, TableView, _ref;
  TableHeaderRegionType = Marionette.Region.extend({
    el: ".tableHeader",
    open: function(view) {
      return this.$el.replaceWith(view.el);
    }
  });
  TableBodyRegionType = Marionette.Region.extend({
    el: ".tableBody",
    open: function(view) {
      return this.$el.replaceWith(view.el);
    }
  });
  return TableView = (function(_super) {
    __extends(TableView, _super);

    function TableView() {
      _ref = TableView.__super__.constructor.apply(this, arguments);
      return _ref;
    }

    TableView.prototype.template = "<thead class='tableHeader'></thead><tbody class='tableBody'></tbody>";

    TableView.prototype.tagName = "table";

    TableView.prototype.regions = {
      tableHeaderRegion: TableHeaderRegionType,
      tableBodyRegion: TableBodyRegionType
    };

    TableView.prototype.eventBus = _.extend({}, Backbone.Events);

    return TableView;

  })(BaseLayout);
});