// events-indexの動的表示

jQuery(document).ready(function() {
  $('.events-index').children('div').hide();
	$('input[name="select-calendar[]"]').change(function() {
    // 初期化
    $('input[name="selected-calendars"]').remove();
    $('.events-index').children('div').hide();

    // submitへのhidden要素追加
    var selected_calendars = [];
    var selected_calendars_name = [];
    $('input[name="select-calendar[]"]:checked').each(function() {
      selected_calendars.push($(this).attr('id'));
      selected_calendars_name.push($(this).val());
    });
    $('<input>').attr({
      'type': 'hidden',
      'name': 'selected_calendars',
      'value': selected_calendars
    }).appendTo($('.selected-calendar'));

    // events-indexの要素表示
    if (selected_calendars.length === 0) {
      $('.events-index p').show();
    } else {
      $.each(selected_calendars, function(index, value) {
        $('.events-index p').hide();
        $('.events-index').children('.' + value).show();
        $('.event-title').addClass('overflow-auto');
      });
    };
	});
});
