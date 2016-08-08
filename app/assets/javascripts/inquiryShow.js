var teacher = $('#teacher_name option:first-child').val();

$(document).ready(function() {
  returnTeachers();
  availabilities(teacher);
});

$('#instrument_name').change(function() {
  returnTeachers();
  $('.inquiry-calendar').empty();
  availabilities(teacher);
});

var returnTeachers = function(){
  var instrument = $('#instrument_name option:selected').text();
  $.ajax({
    url: "/api/v1/teacher",
    method: "GET",
    data: {instrument: instrument},
    dataType: "json",
    success: function(response){
      $("#teacher_name").empty();
      var teachers = response.teachers;
      var teachersNames = response.fullNames;
      for (var i = 0; i < teachers.length; i++) {
        var teacher = $("<option>", {
          value: teachers[i].id,
          text: teachersNames[i]
        });
        $("#teacher_name").append(teacher);
      }
    }
  });
};

$('#teacher_name').change(function() {
  $('.inquiry-calendar').empty();
  var teacher = $('#teacher_name').val();
  availabilities(teacher);
});

var availabilities = function(teacher){
  var inquiry = window.location.pathname.split("/")[2];
  $.ajax({
    url: "/teachers/" + teacher,
    method: "GET",
    data: {id: teacher, inquiry: inquiry},
    dataType: "json",
    success: function(response){
      printCalendar(response);
    }
  });
};

var printCalendar = function(response){
  var dayAbbr = function(day){
    return day.slice(0, 3);
  };

  var $container = $("<div>", {
    "class": "small-12 columns"
  });
  var $headerRow = $("<div>", {
    "class": "row"
  });

  $(".inquiry-calendar").append($container);
  $(".inquiry-calendar").append($headerRow);
  $($headerRow).append( $("<div>", {
    "class": "small-1 columns time-header", text: "Time"
    })
  );

  $.each(daysOfTheWeek, function(index, day){
    var $div = $("<div>", {
      "class": "small-1 columns day-header ", text: dayAbbr(day)
    });
    addEndToLastBlock($div, index);
    $($headerRow).append($div);
  });
  printRows(response);
  getTeachersLessons(response);
};

var getTeachersLessons = function(response){
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
};

var placeLessons = function(lessons){
  for (var i = 0; i < lessons.length; i++) {
    var lesson = lessons[i];
    var lessonId = lesson.id;
    var lessonArray = lessonId.split('-');
    var lessonBlockId = lessonArray[1] + '-' + lessonArray[2];
    var lessonRow = $('#' + lessonBlockId );
    lessonRow.append(lesson);
    lesson.style.width = lessonRow.width() + "px";
  }
};

var daysOfTheWeek = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"];

var printRows = function(response){
  var days = function(index, day){
    var $blocks = $("<div>", {
      "class": "small-1 columns schedule-block teacher-unavailable", id: day + "-" + idTime
    });
    addEndToLastBlock($blocks, index);
    var styleAvailableBlock = function(day, response){
      var teacherAvail = response.availability;
      if(teacherAvail[day].start_time && teacherAvail[day].end_time){
        var teacherStartTime = moment.utc(teacherAvail[day].start_time);
        var teacherEndTime = moment.utc(teacherAvail[day].end_time);
        if(time >= teacherStartTime && time <= teacherEndTime){
          $($blocks).removeClass('teacher-unavailable');
          var studentAvail = response.student_avail;
          var studentStartTime = moment.utc(studentAvail[day].start_time);
          var studentEndTime = moment.utc(studentAvail[day].end_time);
          if(time < studentStartTime || time > studentEndTime){
            $($blocks).addClass('student-unavailable');
          }
        }
      }
    };

    styleAvailableBlock(day, response);
    $("#"+ idTime).append($blocks);
  };

  var time = moment.utc(response.time);
  var endTime = moment.utc(response.endTime);
  while(time <= endTime){
    var idTime = time.format("hhmmA");
    var textTime = time.format("hh:mmA");
    $('.inquiry-calendar').append( $("<div>", {
      "class": "row",
      id: idTime
    })
  );
  $('#' + idTime).append( $("<div>", {
    "class": "small-1 columns time-header",
    text: textTime
  })
);
$.each(daysOfTheWeek, days);
time = moment(time).add(15, 'minutes');
}
};

var resizeLessons = function(){
  var lessons = $('div[id^="lesson-"]');
  for (var i = 0; i < lessons.length; i++) {
    lessons[i].style.width = (lessons[i].parentElement.offsetWidth - 2) + "px";
  }
};

$(window).resize(function(){
  resizeLessons();
});

var addEndToLastBlock = function(variable, index){
  if (index == 6) {
    variable.addClass('end');
  }
};
