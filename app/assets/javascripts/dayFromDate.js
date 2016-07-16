$('#lesson_start_date').on('input', function(){
  let startDate = (this.value);
  let dayOfWeek = new Date(startDate).getDay();
  let day = dayOfWeekAsString(dayOfWeek);
  $("#lesson_day").val(day);
  $('#dayValue').html(day);
});

function dayOfWeekAsString(dayIndex) {
  return ["Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"][dayIndex];
}
