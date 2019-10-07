$(document).ready(function() {
  full_calendar();
});

function full_calendar(url = '/home/index.json') {
  $('#calendar').fullCalendar({
    events: url,
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
        url: 'events/' + event.id + '.js',
      });
    }
  });
};
