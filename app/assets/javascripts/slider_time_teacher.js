$(document).ready(function() {
  var submitButtonTeacher = $('#submit_teacher');

  var setTime = function(day, i){
    $("#teacher_availabilities_attributes_" + i + "_start_time")[0].value = $('.slider-time-' + day)[0].innerText;
    $("#teacher_availabilities_attributes_" + i + "_end_time")[0].value = $('.slider-time2-'+ day)[0].innerText;
  };

  submitButtonTeacher.on("click", function(event) {
    var days = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"];
    for(var i = 0; i < days.length; i++) {
      setTime(days[i], i);
    }
  });
});
