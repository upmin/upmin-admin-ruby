function runJettyAdmin() {
  var JettyAdmin = window.JettyAdmin;
  var controller = $("body").data("controller");
  var action = $("body").data("action");

  if ("object" === typeof JettyAdmin) {

    // Check if a controller specific initializer exists.
    var Controller = JettyAdmin[controller];
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
$(document).ready(runJettyAdmin);
