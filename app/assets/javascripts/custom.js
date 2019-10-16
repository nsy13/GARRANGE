// Topページ
jQuery(document).ready(function() {
  // 選択したカレンダーに登録されたイベントを表示
	$('input[name="select-calendar"]').change(function() {
    $('input[name="selected_calendars"]').remove();
    var selected_calendars = [];
    $('input[name="select-calendar"]:checked').each(function() {
      selected_calendars.push($(this).attr('id'));
    });
    $('<input>').attr({
      'type': 'hidden',
      'name': 'selected_calendars',
      'value': selected_calendars
    // イベント作成フォームのデフォルトカレンダーを表示しているカレンダーに設定
    }).appendTo($('.sidebar__newEvent--form, .select-calendar-form'));
    Rails.fire($('.select-calendar-form')[0], 'submit');
	});
});

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

// モーダル関係
$('.modal').on('shown.bs.modal', function() {
  // 招待されたイベントへの参加
  $('.participateSubmit').click(function() {
    $('.attendance-form').submit();
  });

  // イベント作成フォームの参加者検索
  $('.searched-users').children().hide();
  $('input[name="user_name_or_email"]').keyup(function() {
    $('.searched-users').children().hide();
    $('input[name="search_user"]:checked').parent().show();
    var user_info = $('input[name="user_name_or_email"]').val();
    $('.searched-users').children($("[class*='" + user_info + "']")).show();
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
    }).appendTo($('.modal__newEvent--form, .modal__searchDate--form'));
  });
  $('.modal__newEvent--submit').click(function() {
    $('.modal__newEvent--submitDisplayNone').click();
  });

  // 日程検索フォーム
  $('.modal__searchDate--submit').click(function() {
    $('span').click();
    Rails.fire($('.modal__searchDate--form')[0], 'submit');
  });

  $('input[name="select_date"]').change(function() {
    console.log('hello');
    // $('input[name="selected-date]').remove();
    // var selected_date = $('input[name="date_select"]:checked').val();
    // $('<input>').attr({
      //   'type': 'hidden',
      //   'name': 'selected-date',
      //   'value': selected_date
      // }).appendTo($('#event-modal-form'));
  });
});
