(function() {

  // Methods used in datetime parsing and setting.
  function parseDate(dateString) {
    var matches = dateString.match(/(\d+).(\d+).(\d+)/i);
    if (matches == null || matches.length < 4) {
      return null;
    } else {
      var m = moment();
      m.utc().year(matches[1]);
      m.utc().month(matches[2]);
      m.utc().date(matches[3]);
      return m;
    }
  }

  function setInputDate(newMoment, hiddenInput) {
    if (newMoment == null || !newMoment.isValid()) {
      hiddenInput.val("");
      return null;
    }

    var curMoment = moment(hiddenInput.val());
    if (!curMoment.isValid()) {
      curMoment = newMoment;
    } else {
      curMoment.utc().year(newMoment.utc().year());
      curMoment.utc().month(newMoment.utc().month());
      curMoment.utc().date(newMoment.utc().date());
    }
    hiddenInput.val(curMoment.utc().format());
    return curMoment;
  }

  function parseTime(timeString) {
    var matches = timeString.match(/(\d+)(?::(\d\d))?\s*(p?)/i);
    if (matches == null || matches.length < 4) {
      return null;
    } else {
      var m = moment();

      var h = parseInt(matches[1]);
      if (h == 12 && !matches[3]) {
        h = 0
      } else if (matches[3]) {
        h += (h < 12) ? 12 : 0;
      }
      m.utc().hour(h);
      m.utc().minute(matches[2]);
      return m;
    }
  }

  function setInputTime(newMoment, hiddenInput) {
    if (newMoment == null || !newMoment.isValid()) {
      hiddenInput.val("");
      return null;
    }

    var curMoment = moment(hiddenInput.val());
    if (!curMoment.isValid()) {
      curMoment = newMoment;
    } else {
      curMoment.utc().hour(newMoment.utc().hour());
      curMoment.utc().minute(newMoment.utc().minute());
    }
    hiddenInput.val(curMoment.utc().format());
    return curMoment;
  }






  // Initializing the attribute view.
  var init = function(formId) {
    var dtSection = $("." + formId + ".datetime-attribute");
    var hiddenInput = dtSection.find("input#" + formId + "[type=hidden]");
    var dateInput = dtSection.find("#" + formId + "-date");
    var timeInput = dtSection.find("#" + formId + "-time");

    var dtMoment = moment(hiddenInput.val());
    if (hiddenInput.val() == "") {
      dtMoment = null;
    }

    var handleDateSelect = function() {
      var newDateMoment = parseDate(dateInput.val());
      setInputDate(newDateMoment, hiddenInput);
      return newDateMoment;
    }

    var handleTimeSelect = function() {
      var newTimeMoment = parseTime(timeInput.val());
      setInputTime(newTimeMoment, hiddenInput);
      return newTimeMoment;
    }

    // Create Date Picker
    var datePicker = new Pikaday({ field: $("#" + formId + "-date")[0], onSelect: handleDateSelect });

    // Create Time Picker
    $("#" + formId + "-time").clockpicker({
      autoclose: true,
      donetext: "Done",
      twelvehour: true,
      afterDone: handleTimeSelect,
    });

    if (dtMoment != null) {
      timeInput.val(dtMoment.utc().format("hh:mmA"));
    }

    dtSection.closest("form").submit(function(event) {
      event.preventDefault();

      // Only date is *required* so the order here is important.
      handleTimeSelect();
      handleDateSelect();

      event.target.submit();
    });
  }


  if (window.Upmin == null) {
    window.Upmin = {};
  }
  if (window.Upmin.Attributes == null) {
    window.Upmin.Attributes = {};
  }
  window.Upmin.Attributes.DateTime = init;
})();
