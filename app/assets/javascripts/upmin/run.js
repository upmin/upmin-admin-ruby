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
