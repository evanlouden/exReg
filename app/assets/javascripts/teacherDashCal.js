$(document).ready(function(){
  getTeachersLessons();
});

$(window).resize(function(){
  resizeLessons();
});

var getTeachersLessons = function(){
  var path = window.location.pathname;

  $.ajax({
    url: path,
    method: "GET",
    dataType: "json",
    success: function(response){
      var lessonDivs = [];
      for (var i = 0; i < response.lessons.length; i++) {
        var startTime = moment.utc(response.lessons[i].start_time);
        var $div = $("<div>", {
          id: "lesson-" + response.lessons[i].day + "-" + startTime.format("hhmmA"),
          "class": "lesson-block-" + response.lessons[i].duration,
          data: {"id": response.lessons[i].id}
        });
        $div.text(response.students[i]);
        lessonDivs.push($div[0]);
      }
      placeLessons(lessonDivs);
    }
  });
};

var placeLessons = function(lessons){
  for (var i = 0; i < lessons.length; i++) {
    var lesson = lessons[i];
    var lessonId = lesson.id;
    var lessonArray = lessonId.split('-');
    var lessonBlockId = lessonArray[1] + '-' + lessonArray[2];
    var lessonRow = $('#' + lessonBlockId );
    var lessonPosition = lessonRow.position();
    lessonRow.append(lesson);
    lesson.style.width = lessonRow.width() + "px";
  }
};

var resizeLessons = function(){
  var lessons = $('div[id^="lesson-"]');
  for (var i = 0; i < lessons.length; i++) {
    lessons[i].style.width = lessons[i].parentElement.offsetWidth + "px";
  }
};
