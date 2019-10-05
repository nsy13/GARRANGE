jQuery(document).ready(function() {
	$('input[name="select-calendar[]"]').change(function() {
    var selected_calendars = [];
    $('input[name="select-calendar[]"]:checked').each(function() {
      // 値を配列に格納
      selected_calendars.push($(this).attr('id'));
    });
    $('input[name="selected-calendars"]').remove();
    $('<input>').attr({
      'type': 'hidden',
      'name': 'selected_calendars',
      'value': selected_calendars
    }).appendTo($('.selected-calendar'));
	});
});