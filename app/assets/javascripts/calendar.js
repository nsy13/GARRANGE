$(document).ready(function() {
  var user_id = $('input[name="user_id"]').val();
  full_calendar("?user_id=" + user_id);
});

function full_calendar(url = "") {
  $('#calendar').fullCalendar({
    events: '/home/index.json' + url,
    header: {
      left: 'prev, next, today',
      center: 'title',
      right: 'month, agendaWeek, agendaDay',
    },
    titleFormat: 'YYYY年 M月',
    buttonText: {
      today: '今日',
      month: '月',
      week: '週',
      day: '日'
    },
    dayNamesShort: ['日','月','火','水','木','金','土'],
    timeFormat: "HH:mm",
    selectable: true,
    editable: true,
    eventClick: function(event, jsEvent, view) {
      $.ajax({
        type: 'GET',
        url: '/events/' + event.id + '.js',
      });
    }
  });
};
