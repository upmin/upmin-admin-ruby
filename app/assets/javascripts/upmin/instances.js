var Instances = {
  init: function() {
    return console.log("Init Instances JS...");
  },


  Show: {
    init: function() {
      console.log("Init Instances.Show JS...");
    }, // end of Search.init()

  } // end of Search




};

if (window.Upmin == null) {
  window.Upmin = {};
}

window.Upmin.Instances = Instances;
