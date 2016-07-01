$(document).ready(function() {
  var submitButton = $('#submit');

  var setTime = function(day, i){
    $("#student_availabilities_attributes_" + i + "_start_time")[0].value = $('.slider-time-' + day)[0].innerText;
    $("#student_availabilities_attributes_" + i + "_end_time")[0].value = $('.slider-time2-'+ day)[0].innerText;
  };

  submitButton.on("click", function(event) {
    var days = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"];
    for(var i = 0; i < days.length; i++) {
      setTime(days[i], i);
    }
  });
});
