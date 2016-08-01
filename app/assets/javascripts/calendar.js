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
    }
  });
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
