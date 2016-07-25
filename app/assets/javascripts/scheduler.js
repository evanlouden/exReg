$(document).ready(function(){
  placeLesson();
});

var placeLesson = function(){
  var lessonRow = $('#Monday-0400PM');
  var lessonPosition = lessonRow.position();
  $('#lesson-Monday-0400PM').css({"top": lessonPosition.top, "left": lessonPosition.left, "width": lessonRow.width()});
};

$(window).resize(function(){
  placeLesson();
});

var getTeachers = function(){
  $.ajax({
    url: "api/teacher",
    method: "GET",
    dataType: "json",
    success: function(response){
      console.log(response);
    }
  });
}
