$('#dropped_lesson_form_lesson_amount').on('input', function(){
  var lessonCount = $(this).val();
  var lessonPrice = $(".price-info").text().trim().split("$")[1];
  var creditAmount = lessonCount * lessonPrice;
  $('#dropped_lesson_form_transaction_amount').val(creditAmount);
});
