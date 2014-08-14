// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require_tree .

function runUpmin() {
  var Upmin = window.Upmin;
  var controller = $("body").data("controller");
  var action = $("body").data("action");

  if ("object" === typeof Upmin) {

    // Check if a controller specific initializer exists.
    var Controller = Upmin[controller];
    if ("object" === typeof Controller) {
      Controller.init();

      // Check if an action specific initializer exists.
      var Action = Controller[action];
      if ("object" === typeof Action) {
        Action.init();
      }
    }
  }
};
$(document).ready(runUpmin);
