$('#teacher_calendar').change(function() {
  $(".admin-calendar").empty();
  var teacherId = $(this).find(":selected").context.value;

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
    var $div = "";
    if (index == 6) {
      $div = $("<div>", {
        "class": "small-1 columns end day-header ", text: dayAbbr(day)
      });
    } else {
      $div = $("<div>", {
        "class": "small-1 columns day-header", text: dayAbbr(day)
      });
    }
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
      getTeachersLessons(id, response);
    }
  });

  var getTeachersLessons = function(id, response){
    var lessonDivs = [];
    for (var i = 0; i < response.lessons.length; i++) {
      var startTime = new Date(response.lessons[i].start_time);
      var hr = startTime.getUTCHours();
      var ampm = "AM";
      if (hr > 12) {
        ampm = "PM";
        hr -= "12";
        hr = "0" + hr;
      } else if(hr == 12){
        ampm = "PM";
      }
      var min = startTime.getUTCMinutes();
      if (min < 10) {
        min = "0" + min;
      }
      var $div = $("<div>", {
        id: "lesson-" + response.lessons[i].day + "-" + hr + min + ampm,
        "class": "lesson-block-" + response.lessons[i].duration,
        data: {"id": response.lessons[i].id}
      });
      $div.text(response.students[i]);
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
    var $blocks = "";
    if (index == 6) {
      $blocks = $("<div>", {
        "class": "small-1 columns end schedule-block shaded", id: day + "-" + idTime
      });
    } else {
      $blocks = $("<div>", {
        "class": "small-1 columns schedule-block shaded", id: day + "-" + idTime
      });
    }
    var styleAvailableBlock = function(day, response){
      var availabilities = response.availability;
      if(availabilities[day].start_time && availabilities[day].end_time){
        var availStartTime = moment.utc(availabilities[day].start_time);
        var availEndTime = moment.utc(availabilities[day].end_time);
        if(time >= availStartTime && time <= availEndTime){
          $($blocks).removeClass('shaded').droppable( { drop:function(event, ui) {
              ui.draggable.detach().appendTo($(this)); }
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
