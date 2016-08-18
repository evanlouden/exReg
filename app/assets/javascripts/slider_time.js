$(document).ready(function() {
  var submitButton = $('#submit');

  var setTime = function(day){
    $("#student_form_" + day + "_start_time")[0].value = $('.slider-time-' + day).text();
    $("#student_form_" + day + "_end_time")[0].value = $('.slider-time2-'+ day).text();
  };

  submitButton.on("click", function(event) {
    var days = ["sunday", "monday", "tuesday", "wednesday", "thursday", "friday", "saturday"];
    for(var i = 0; i < days.length; i++) {
      setTime(days[i]);
    }
  });
});
