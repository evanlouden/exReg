$(document).ready(function() {
  var dayAbbr = function(day){
    return day.slice(0, 3);
  };

  var $container = $("<div>", {
    "class": "small-12 columns"
  });
  var $headerRow = $("<div>", {
    "class": "row"
  });

  $(".teacher-calendar").append($container);
  $(".teacher-calendar").append($headerRow);
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

  generateCalendar();
});

var generateCalendar = function(){
  var path = window.location.pathname;

  $.ajax({
    url: path,
    method: "GET",
    dataType: "json",
    success: function(response){
      debugger;
      printRows(response);
      getTeachersLessons(response);
    }
  });

  var getTeachersLessons = function(response){
    var lessonDivs = [];
    for (var i = 0; i < response.lessons.length; i++) {
      var startTime = moment.utc(response.lessons[i].start_time);
      var $div = $("<div>", {
        id: "lesson-" + response.lessons[i].day + "-" + startTime.format("hhmmA"),
        "class": "lesson-block-" + response.lessons[i].duration,
        data: {"id": response.lessons[i].id},
        text: response.students[i] + " (" + response.lessonsRemaining[i] + ")"
      });
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
};

var daysOfTheWeek = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"];

var printRows = function(response){
  var days = function(index, day){
    var $blocks = $("<div>", {
      "class": "small-1 columns schedule-block teacher-unavailable", id: day + "-" + idTime
    });
    addEndToLastBlock($blocks, index);
    var styleAvailableBlock = function(day, response){
      var availabilities = response.availability;
      if(availabilities[day].start_time && availabilities[day].end_time){
        var availStartTime = moment.utc(availabilities[day].start_time);
        var availEndTime = moment.utc(availabilities[day].end_time);
        if(time >= availStartTime && time <= availEndTime){
          $($blocks).removeClass('teacher-unavailable');
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
    $('.teacher-calendar').append( $("<div>", {
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
