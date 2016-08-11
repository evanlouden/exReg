$(document).ready(function() {
  returnTeachers();
  dayFromDate();
});

$('#lesson_instrument').change(function() {
  returnTeachers();
});

$('#lesson_start_date').on('input', function(){
  dayFromDate();
});

var returnTeachers = function(){
  var instrument = $('#instrument_name option:selected').text();
  $.ajax({
    url: "/api/v1/teacher",
    method: "GET",
    data: {instrument: instrument},
    dataType: "json",
    success: function(response){
      $("#lesson_teacher_id").empty();
      var teachers = response.teachers;
      var teachersNames = response.fullNames;
      for (var i = 0; i < teachers.length; i++) {
        var teacher = $("<option>", {
          value: teachers[i].id,
          text: teachersNames[i]
        });
        $("#lesson_teacher_id").append(teacher);
      }
    }
  });
};

var dayFromDate = function(){
  var dayOfWeek = moment($('#lesson_start_date').val()).day();
  var day = dayOfWeekAsString(dayOfWeek);
  $("#lesson_day").val(day);
  $('#dayValue').html(day);
};

function dayOfWeekAsString(dayIndex) {
  return ["Sunday", "Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"][dayIndex];
}
