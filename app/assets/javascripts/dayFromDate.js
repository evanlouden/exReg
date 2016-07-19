$('#lesson_start_date').on('input', function(){
  var startDate = (this.value);
  var dayOfWeek = new Date(startDate).getDay();
  var day = dayOfWeekAsString(dayOfWeek);
  $("#lesson_day").val(day);
  $('#dayValue').html(day);
});

function dayOfWeekAsString(dayIndex) {
  return ["Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"][dayIndex];
}
