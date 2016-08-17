// $(document).ready(function() {
//   var submitButtonTeacher = $('#submit_teacher');
//
//   var setTime = function(day, i){
//     $("#teacher_availabilities_attributes_" + i + "_start_time")[0].value = $('.slider-time-' + day)[0].innerText;
//     $("#teacher_availabilities_attributes_" + i + "_end_time")[0].value = $('.slider-time2-'+ day)[0].innerText;
//   };
//
//   submitButtonTeacher.on("click", function(event) {
//     var days = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"];
//     for(var i = 0; i < days.length; i++) {
//       setTime(days[i], i);
//     }
//   });
// });

$(document).ready(function() {
  var submitButtonTeacher = $('#submit_teacher');

  var setTime = function(day){
    $("#teacher_form_" + day + "_start_time")[0].value = $('.slider-time-' + day).text();
    $("#teacher_form_" + day + "_end_time")[0].value = $('.slider-time2-'+ day).text();
  };

  submitButtonTeacher.on("click", function(event) {
    var days = ["sunday", "monday", "tuesday", "wednesday", "thursday", "friday", "saturday"];
    for(var i = 0; i < days.length; i++) {
      setTime(days[i]);
    }
  });
});
