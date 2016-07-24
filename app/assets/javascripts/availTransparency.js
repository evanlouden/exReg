$(document).ready(function(){
  var days = ["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"];
  for (var i = 0; i < days.length; i++) {
    if ($("#" + days[i] + " > :input[type=checkbox]").is(":checked")) {
      $("#" + days[i]).parent().css({"opacity": "1.0"});
    }
  }
});

$(':checkbox').change(function() {
  if ($(this).is(":checked")) {
    $(this).parents(".avail-block").css({"opacity": "1.0"});
  } else {
    $(this).parents(".avail-block").css({"opacity": "0.7"});
  }
});
