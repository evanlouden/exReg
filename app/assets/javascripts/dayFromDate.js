$('#lesson_start_date').on('input', function(){
  let startDate = (this.value);
  let dayOfWeek = new Date(startDate).getDay();
  let day = dayOfWeekAsString(dayOfWeek);
  $('#dayValue').html(
    "<input type='text' name='lesson[day]' id='lesson_day' value='" + day +"'>"
    );
});

function dayOfWeekAsString(dayIndex) {
  return ["Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"][dayIndex];
}
