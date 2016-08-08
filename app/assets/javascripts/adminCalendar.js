$('#teacher_calendar').change(function() {
  $(".admin-calendar").empty();
  var teacherId = $(this).val();

  var dayAbbr = function(day){
    return day.slice(0, 3);
  };

  var $container = $("<div>", {
    "class": "small-12 columns"
  });
  var $headerRow = $("<div>", {
    "class": "row"
  });

  $(".admin-calendar").append($container);
  $(".admin-calendar").append($headerRow);
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

  generateCalendar(teacherId);
});

var generateCalendar = function(id){
  $.ajax({
    url: "/api/v1/calendar",
    method: "GET",
    data: {id: id},
    dataType: "json",
    success: function(response){
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

  $('#revertButton').on("click", function(event){
    event.preventDefault();
    var lessons = $('div[id^="lesson-"]');
    placeLessons(lessons);
    hideButtons();
  });

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
    addDraggable();
  };

  var addDraggable = function(){
    var lessonBlocks = $('div[class^="lesson-block-"]');
    lessonBlocks.draggable({
        helper:"clone",
        revert: "invalid",
        stop: function(){
          $('#calendarButton').removeClass('hidden-submit');
          $('#revertButton').removeClass('hidden-submit');
        }
    });
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
          $($blocks).removeClass('teacher-unavailable').droppable( {
            drop: function(event, ui){
              var dayId = $(this).attr('id').split("-")[0];
              var dayBlocks = $('div[id^="'+dayId+'-"]').not(".teacher-unavailable");
              var blockIndex = $(dayBlocks).index(this);
              if (this === dayBlocks[dayBlocks.length - 1]){
                return false;
              } else if (!$(ui.draggable).hasClass('lesson-block-30') && this === dayBlocks[dayBlocks.length - 2]) {
                return false;
              } else if ($(ui.draggable).hasClass('lesson-block-60') && this === dayBlocks[dayBlocks.length - 3]) {
                return false;
              } else if (this.hasChildNodes()) {
                return false;
              } else {
                var changeDroppable = function(lessonLength, index, boolean){
                  var i = (lessonLength / 15) - 1;
                  while (i > 0) {
                    $(dayBlocks[index + i]).droppable("option", "disabled", boolean);
                    i--;
                  }
                };
                var lessonTime = $(ui.draggable).attr('class').slice(13,15);
                var parent = $(ui.draggable).parent();
                var parentIndex = $(dayBlocks).index(parent);
                changeDroppable(lessonTime, parentIndex, false);
                ui.draggable.detach().appendTo($(this));
                changeDroppable(lessonTime, blockIndex, true);
              }
            },
          });
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
    $('.admin-calendar').append( $("<div>", {
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

$('#calendarButton').on("click", function(event){
  event.preventDefault();
  updateSchedule();
});

var updateSchedule = function(){
  var divsToUpdate = changedLessons();
  var updatedLessons = [];
  for (var i = 0; i < divsToUpdate.length; i++) {
    var id = $(divsToUpdate[i]).data().id;
    var newTimeValue = divsToUpdate[i].parentElement.id;
    var day = newTimeValue.split("-")[0];
    var rawTime = newTimeValue.split("-")[1];
    var time = rawTime.slice(0,2) + ":" + rawTime.slice(2, 6);
    var lesson = {
      id: id,
      day: day,
      start_time: time
    };
    updatedLessons.push(lesson);
  }
  $.ajax({
    url: "/api/v1/calendar",
    method: "POST",
    data: JSON.stringify({"lessons": updatedLessons}),
    dataType: "json",
    contentType: "application/json",
    success: function(response)
    {
      console.log("WoO");
      var divsToUpdate = changedLessons();
      $.each(divsToUpdate, function(index, div) {
        var idToWrite = div.parentElement.id;
        div.setAttribute('id', 'lesson-' + idToWrite);
      });
      hideButtons();
      $(divsToUpdate).delay(50).fadeOut(50).fadeIn(400);
    }
  });
};

var hideButtons = function(){
  $('#calendarButton').addClass('hidden-submit');
  $('#revertButton').addClass('hidden-submit');
};

var changedLessons = function(){
  var lessons = $('div[id^="lesson-"]');
  var divsToUpdate = $.grep(lessons, function(n, i){
    var idArray = n.id.split("-");
    var comparableId = idArray[1] + '-' + idArray[2];
    return comparableId != n.parentElement.id;
  });
  return divsToUpdate;
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
