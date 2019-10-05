jQuery(document).ready(function() {
  $('.events-list').children('div').hide();
	$('input[name="select-calendar[]"]').change(function() {
    // 初期化
    $('input[name="selected-calendars"]').remove();
    $('.events-list').children('div').hide();

    // submitへのhidden要素追加
    var selected_calendars = [];
    $('input[name="select-calendar[]"]:checked').each(function() {
      selected_calendars.push($(this).attr('id'));
    });
    $('<input>').attr({
      'type': 'hidden',
      'name': 'selected_calendars',
      'value': selected_calendars
    }).appendTo($('.selected-calendar'));

    // events-listの要素表示
    if (selected_calendars.length === 0) {
      $('.events-list p').show();
    } else {
      $.each(selected_calendars, function(index, value) {
        $('.events-list p').hide();
        $('.events-list').children('.' + value).show();
      });
    }
	});
});