$('#teacher_calendar').change(function() {
  // var teacherId = $(this).find(":selected").context.value;
  clearLessons();
  // getTeachersLessons(teacherId);
  // $('.schedule-block').droppable( { drop:function(event, ui) {
  //       ui.draggable.detach().appendTo($(this)); }
  //   });
});

$('#calendarButton').on("click", function(event){
  event.preventDefault();
  updateSchedule();
});

$('#revertButton').on("click", function(event){
  event.preventDefault();
  var lessons = $('div[id^="lesson-"]');
  placeLessons(lessons);
  hideButtons();
});

$(window).resize(function(){
  resizeLessons();
});

// var getTeachersLessons = function(id, response){
//     var lessonDivs = [];
//     for (var i = 0; i < response.lessons.length; i++) {
//       var startTime = new Date(response.lessons[i].start_time);
//       var hr = startTime.getUTCHours();
//       var ampm = "AM";
//       if (hr > 12) {
//         ampm = "PM";
//         hr -= "12";
//         hr = "0" + hr;
//       } else if(hr == 12){
//         ampm = "PM";
//       }
//       var min = startTime.getUTCMinutes();
//       if (min < 10) {
//         min = "0" + min;
//       }
//       var $div = $("<div>", {
//         id: "lesson-" + response.lessons[i].day + "-" + hr + min + ampm,
//         "class": "lesson-block-" + response.lessons[i].duration,
//         data: {"id": response.lessons[i].id}
//       });
//       $div.text(response.students[i]);
//       lessonDivs.push($div[0]);
//     }
//     placeLessons(lessonDivs);
//   };
// };
//
// var placeLessons = function(lessons){
//   for (var i = 0; i < lessons.length; i++) {
//     var lesson = lessons[i];
//     var lessonId = lesson.id;
//     var lessonArray = lessonId.split('-');
//     var lessonBlockId = lessonArray[1] + '-' + lessonArray[2];
//     var lessonRow = $('#' + lessonBlockId );
//     lessonRow.append(lesson);
//     lesson.style.width = lessonRow.width() + "px";
//   }
//   addDraggable();
// };

var resizeLessons = function(){
  var lessons = $('div[id^="lesson-"]');
  for (var i = 0; i < lessons.length; i++) {
    lessons[i].style.width = (lessons[i].parentElement.offsetWidth - 2) + "px";
  }
};

var clearLessons = function(){
  var lessons = $('div[id^="lesson-"]');
  for (var i = 0; i < lessons.length; i++) {
    lessons[i].remove();
  }
};

// var addDraggable = function(){
//   var lessonBlocks = $('div[class^="lesson-block-"]');
//   lessonBlocks.draggable({
//       helper:"clone",
//       stop: function(){
//         $('#calendarButton').removeClass('hidden-submit');
//         $('#revertButton').removeClass('hidden-submit');
//       }
//   });
// };

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
