$(document).ready(function(){
  var path = window.location.pathname;
  var id = path.split("/")[2];

  var request = $.ajax({
    method: "GET",
    url: "/students/" + id + "/edit",
    dataType: "json",
    success: function(response){
      var days = ["sunday", "monday", "tuesday", "wednesday", "thursday", "friday", "saturday"];

      for (var i = 0; i < days.length; i++) {
        for (var j = 0; j < response.length; j++) {
          if (response[j].day !== days[i]) {
            slickSlider(days[i].toLowerCase(), 600, 720);
            $('.slider-time-' + days[i].toLowerCase()).html("10:00 AM");
            $('.slider-time2-' + days[i].toLowerCase()).html("12:00 PM");
          }
        }
      }

      for (var k = 0; k < response.length; k++) {
        slickSlider(
          response[k].day.toLowerCase(),
          convertTimes(response[k].start_time),
          convertTimes(response[k].end_time));
          $('.slider-time-' + response[k].day.toLowerCase()).html(moment.utc(response[k].start_time).format("h:mm A"));
          $('.slider-time2-' + response[k].day.toLowerCase()).html(moment.utc(response[k].end_time).format("h:mm A"));
          $('#student_form_' + response[k].day.toLowerCase() + '_checked').prop("checked", true);
      }

      for (var l = 0; l < days.length; l++) {
        if ($("#" + days[l] + " > :input[type=checkbox]").is(":checked")) {
          $("#" + days[l]).parent().css({"opacity": "1.0"});
        }
      }
    }
  });
});

var convertTimes = function(time){
  a = new Date(time);
  return (a.getUTCHours() * 60) + (a.getUTCMinutes());
};

var slickSlider = function(id, a, b){
  $("#slider-range-" + id).slider({
      range: true,
      min: 540,
      max: 1260,
      step: 15,
      values: [a, b],
      slide: function (e, ui) {
          var hours1 = Math.floor(ui.values[0] / 60);
          var minutes1 = ui.values[0] - (hours1 * 60);

          if (hours1.length == 1) hours1 = '0' + hours1;
          if (minutes1.length == 1) minutes1 = '0' + minutes1;
          if (minutes1 === 0) minutes1 = '00';
          if (hours1 >= 12) {
              if (hours1 == 12) {
                  hours1 = hours1;
                  minutes1 = minutes1 + " PM";
              } else {
                  hours1 = hours1 - 12;
                  minutes1 = minutes1 + " PM";
              }
          } else {
              hours1 = hours1;
              minutes1 = minutes1 + " AM";
          }
          if (hours1 === 0) {
              hours1 = 12;
              minutes1 = minutes1;
          }

          $('.slider-time-' + id).html(hours1 + ':' + minutes1);

          var hours2 = Math.floor(ui.values[1] / 60);
          var minutes2 = ui.values[1] - (hours2 * 60);

          if (hours2.length == 1) hours2 = '0' + hours2;
          if (minutes2.length == 1) minutes2 = '0' + minutes2;
          if (minutes2 === 0) minutes2 = '00';
          if (hours2 >= 12) {
              if (hours2 == 12) {
                  hours2 = hours2;
                  minutes2 = minutes2 + " PM";
              } else if (hours2 == 24) {
                  hours2 = 11;
                  minutes2 = "59 PM";
              } else {
                  hours2 = hours2 - 12;
                  minutes2 = minutes2 + " PM";
              }
          } else {
              hours2 = hours2;
              minutes2 = minutes2 + " AM";
          }

          $('.slider-time2-' + id).html(hours2 + ':' + minutes2);
      }
  });
};

$(':checkbox').change(function() {
  if ($(this).is(":checked")) {
    $(this).parents(".avail-block").css({"opacity": "1.0"});
  } else {
    $(this).parents(".avail-block").css({"opacity": "0.7"});
  }
});
