// events-indexの動的表示

jQuery(document).ready(function() {
  $('.events-index').children('div:gt(0)').hide();
  $('.event-title').addClass('overflow-auto');

	$('input[name="select-calendar"]').change(function() {
    // 初期化
    $('input[name="selected_calendars"]').remove();
    $('.events-index').children('div').hide();

    // submitへのhidden要素追加
    // カレンダー変更に伴う@eventsの動的な変更
    var selected_calendars = [];
    $('input[name="select-calendar"]:checked').each(function() {
      selected_calendars.push($(this).attr('id'));
    });
    $('<input>').attr({
      'type': 'hidden',
      'name': 'selected_calendars',
      'value': selected_calendars
    }).appendTo($('.event-form, .select-calendar-form'));
    Rails.fire($('.select-calendar-form')[0], 'submit');

    // events-indexの要素表示
    if (selected_calendars.length === 0) {
      $('.events-index p').show();
    } else {
      $('.events-index p').hide();
      $.each(selected_calendars, function(index, value) {
        $('.events-index').children('.' + value).show();
        $('.event-title').addClass('overflow-auto');
      });
    };
	});
});

// イベント参加モーダル

$('.modal').on('shown.bs.modal', function() {
  $('.participateSubmit').click(function() {
    $('.attendance-form').submit();
  })
})

// カレンダー編集画面

$(document).ready(function() {
  $('#calendar_id').change(function() {
    var calendar_id = $('#calendar_id').val();
    $.ajax( {
      type: 'GET',
      url: '/calendars/' + calendar_id + '/edit',
    });
  });
});

$(document).ajaxComplete(function() {
  $('#calendar_id').change(function() {
    var calendar_id = $('#calendar_id').val();
    $.ajax( {
      type: 'GET',
      url: '/calendars/' + calendar_id + '/edit',
    });
  });
});

// イベント作成フォームの参加者検索

$('.modal').on('shown.bs.modal', function() {
  $('.searched-users').children().hide();
  $('input[name="user_name_or_email"]').keyup(function() {
    $('.searched-users').children().hide();
    $('input[name="search_user"]:checked').parent().show();
    var user_info = $('input[name="user_name_or_email"]').val();
    $("[class*='" + user_info + "']").show();
  });
  $('input[name="search_user"]').change(function(){
    $('input[name="inviting_users"]').remove();
    var inviting_users = [];
    $('input[name="search_user"]:checked').each(function() {
      inviting_users.push($(this).val());
    });
    $('<input>').attr({
      'type': 'hidden',
      'name': 'inviting_users',
      'value': inviting_users
    }).appendTo($('#event-modal-form'));
  });
  $('.event-form-submit').click(function() {
    $('#event-modal-form').submit();
  });
});
