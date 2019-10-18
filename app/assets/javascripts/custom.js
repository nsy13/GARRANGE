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
function modal_setting() {
  $('.modal').on('shown.bs.modal', function() {
    // datetimepickerの設定
    $('.datetimepicker-input').datetimepicker({ stepping: 30, sideBySide: true });
    $('.datetimepicker-input').on("hide.datetimepicker", function() {
      var start_date = $('#start_date_picker').val();
      var end_date = $('#end_date_picker').val();
      $('.datetimepicker-input').datetimepicker('defaultDate', start_date);
      if (end_date < start_date) {
        $('#end_date_picker').datetimepicker('date', start_date);
      }
    });
    // 招待されたイベントへの参加
    $('.participateSubmit').click(function() {
      $('.attendance-form').submit();
    });

    // 初期値の埋め込み
    $('.searched-users').children().hide();
    $('input[name="search_user"]:checked').parent().show();
    if (typeof inviting_users !== 'undefined') {
      inviting_users.length = 0;
    } else {
      var inviting_users = [];
    };
    $('input[name="search_user"]:checked').each(function() {
      inviting_users.push($(this).val());
    });
    // 日程検索フォーム上のinviting_usersも拾ってしまうので重複をフィルター
    inviting_users = inviting_users.filter(function (x, i, self) {
      return self.indexOf(x) === i;
    });
    $('input[name="inviting_users"]').remove();
    $('<input>').attr({
      'type': 'hidden',
      'name': 'inviting_users',
      'value': inviting_users
    }).appendTo($('.modal_dateToEvent--link, .modal__searchDate--form, .modal__newEvent--form'));

    // イベント作成フォームの参加者リアルタイム検索
    $('input[name="user_name_or_email"]').keyup(function() {
      $('.searched-users').children().hide();
      $('input[name="search_user"]:checked').parent().show();
      var user_info = $('input[name="user_name_or_email"]').val();
      $('.searched-users').find($("[class*='" + user_info + "']")).show();
    });

    // 招待するユーザーの埋め込み
    $('input[name="search_user"]').change(function(){
      $('input[name="inviting_users"]').remove();
      inviting_users.length = 0;
      $('input[name="search_user"]:checked').each(function() {
        inviting_users.push($(this).val());
      });
      $('<input>').attr({
        'type': 'hidden',
        'name': 'inviting_users',
        'value': inviting_users
      }).appendTo($('.modal_dateToEvent--link, .modal__searchDate--form, .modal__newEvent--form'));
    });
    $('.modal__newEvent--submit').click(function() {
      $('.modal__newEvent--submitDisplayNone').click();
    });

    // 日程検索フォーム
    $('.modal__searchDate--submit').click(function() {
      $('.modal__searchDate--submitDisplayNone').click();
    });

    $('input[name="select_date"]').change(function() {
      $('.modal__newEvent--link').click(function() {
        var event_time_hours = $('select[name="[event_time(4i)]"]').find('option:checked').val();
        var event_time_minutes = $('select[name="[event_time(5i)]"]').find('option:checked').val();
        var event_time = Number(event_time_hours) * 60 + Number(event_time_minutes);
        $('<input>').attr({
          'type': 'hidden',
          'name': 'event_time',
          'value': event_time
        }).appendTo($('.modal_dateToEvent--link, .modal__searchDate--form'));
        $('.modal__dateToEvent--submitDisplayNone').click();
      });
    });

    // イベント詳細フォーム
    $('.modal__eventEdit--link').click(function() {
      var event_id = $('input[name="event_id"]').val();
      $('span').click();
      $.ajax( {
        type: 'GET',
        url: '/events/' + event_id + '/edit',
      })
    });
  });
};