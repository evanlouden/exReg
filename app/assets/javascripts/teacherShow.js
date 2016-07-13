$('#teacher_attendance').change(function() {
  window.location = "teachers/" + $(this).find(":selected").context.value;
});
