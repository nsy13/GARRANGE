$(function () {
  function eventCalendar() {
    return $('#calendar').fullCalendar({});
  };
  function clearCalendar() {
    $('#calendar').html('');
  };
  $(document).on('turbolinks:load', function () {
    eventCalendar();
  });
  $(document).on('turbolinks:before-cache', clearCalendar);

  $('#calendar').fullCalendar({
    events: '/home/index.json',
    // eventSources: [
    //   {
    //     url: 'gcals/get_google_calendar_event',
    //     dataType: 'json',
    //     type: 'get'
    //   }
    // ],
  });
});
