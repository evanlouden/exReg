$(document).ready(function(){
  getTeachersLessons();
});

$(window).resize(function(){
  resizeLessons();
});

var getTeachersLessons = function(){
  $.ajax({
    url: "/api/v1/calendar",
    method: "GET",
    dataType: "json",
    success: function(response){
      var lessonDivs = [];
      for (var i = 0; i < response.lessons.length; i++) {
        var startTime = new Date(response.lessons[i].start_time);
        var hr = startTime.getUTCHours();
        var ampm = "AM";
        if (hr > 12) {
          ampm = "PM";
          hr -= "12";
          hr = "0" + hr;
        }
        var min = startTime.getUTCMinutes();
        if (min < 10) {
          min = "0" + min;
        }
        var $div = $("<div>", {
          id: "lesson-" + response.lessons[i].day + "-" + hr + min + ampm,
          "class": "lesson-block-" + response.lessons[i].duration
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
