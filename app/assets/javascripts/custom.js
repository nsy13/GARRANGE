// flashメッセージ
$(function(){
  setTimeout("$('.flash').fadeOut('slow')", 3000)
})

// Topページ
$(document).ready(function() {
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
    }).appendTo($('.sidebar__newEvent--form, .sidebar__calendarsList--form'));
    Rails.fire($('.sidebar__calendarsList--form')[0], 'submit');
	});
});

$(document).ready(function(){
  // カレンダー展開リンクを踏んだ際のアイコン変更
  $('.calendar-collapse').on('click', function(){
    if($(this).attr('aria-expanded') === 'true'){
      $(this).find('i').removeClass('fa-chevron-up');
      $(this).find('i').addClass('fa-chevron-down');
    } else {
      $(this).find('i').removeClass('fa-chevron-down');
      $(this).find('i').addClass('fa-chevron-up');
    }
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

// モーダル関係
function modal_newEvent(){
  $('.modal').on('shown.bs.modal', function() {
    var default_start = $('input[name="event[start_date]"]').val();
    var default_end = $('input[name="event[end_date]"]').val();
    datetimepicker_settings(default_start, default_end);
    realtime_searchUser();
    invite_user('.modal__newEvent--form');
    form_submit('.modal__newEvent--submit', '.modal__newEvent--submitDisplayNone');
    set_invitedUsers('.modal__newEvent--form');
  });
}

function modal_searchDate(){
  $('.modal').on('shown.bs.modal', function() {
    datetimepicker_settings();
    realtime_searchUser();
    invite_user('.modal__dateToEvent--form, .modal__searchDate--form');
    form_submit('.modal__searchDate--submit', '.modal__searchDate--submitDisplayNone');
    form_submit('.modal__newEvent--link', '.modal__dateToEvent--submitDisplayNone');
    set_eventTime('.modal__dateToEvent--form');
    set_invitedUsers('.modal__dateToEvent--form, .modal__searchDate--form');
  });
}

function modal_eventEdit(){
  $('.modal').on('shown.bs.modal', function() {
    var default_start = $('input[name="event[start_date]"]').val();
    var default_end = $('input[name="event[end_date]"]').val();
    datetimepicker_settings(default_start, default_end);
    realtime_searchUser();
    invite_user('.modal__eventEdit--form');
    form_submit('.modal__eventEdit--submit', '.modal__eventEdit--submitDisplayNone');
    set_invitedUsers('.modal__eventEdit--form');
  });
}

function modal_eventDetail(){
  $('.modal').on('shown.bs.modal', function() {
    // 編集ページへのリンク
    $('.modal__eventEdit--link').click(function(){
      modal_close();
      var event_id = $('input[name="event_id"').val();
      ajax_submit('/events/' + event_id + '/edit');
    });

    // 参加フォーム送信
    form_submit('.modal__participateEvent--submit', '.modal__participateEvent--submitDisplayNone')
    modal_hide();
  });
};

//=============== 関数群 =======================
function datetimepicker_settings(default_start, default_end){
  $('.datetimepicker-input').datetimepicker({ stepping: 30, sideBySide: true });
  var start_date = default_start;
  var end_date = default_end;
  $('#start_date_picker').datetimepicker('date', start_date);
  $('#end_date_picker').datetimepicker('date', end_date);
  $('.datetimepicker-input').on("hide.datetimepicker", function() {
    start_date = $('#start_date_picker').val();
    end_date = $('#end_date_picker').val();
    if (end_date < start_date) {
      end_date = start_date;
      $('#end_date_picker').datetimepicker('date', end_date);
    }
    // イベント編集フォーム用のinputタグを更新
    $('input[name="event[start_date]"]').val(start_date);
    $('input[name="event[end_date]"]').val(end_date);
  });
};

function realtime_searchUser(){
  // 初期設定（全て非表示にしたのち選択済みユーザーのみ表示）
  $('.searched-users').children().hide();
  $('input[name="search_user"]:checked').parent().show();
  // リアルタイム検索(全て非表示にしたのち選択済みユーザーのみ表示)
  $('input[name="user_name_or_email"]').keyup(function() {
    $('.searched-users').children().hide();
    $('input[name="search_user"]:checked').parent().show();
    var user_info = $('input[name="user_name_or_email"]').val();
    $('.searched-users').find($("[class*='" + user_info + "']")).show();
  });
};

function invite_user(form){
  // チェックしたユーザーをinput hiddenタグでフォームに埋め込み
  var inviting_users = [];
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
    }).appendTo($(form));
  });
};

function modal_hide() {
  $('.modal__user--link').click(function(){
    $('span').click();
  })
}

function form_submit(formButton, form){
  $(formButton).click(function() {
    $(form).click();
  });
};

function set_invitedUsers(form){
  // inviting_usersがなければ作成、あれば初期化
  if (typeof inviting_users !== 'undefined') {
    inviting_users.length = 0;
  } else {
    var inviting_users = [];
  };
  // コントローラーから渡された選択（チェック）済みユーザーをフォームへ埋め込み
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
  }).appendTo($(form));
};

function set_eventTime(){
  // 設定したイベントの時間（長さ）をsecondsにしてフォームへ埋め込み
  $('.datetime-select').change(function() {
    var event_time_hours = $('select[name="[event_time(4i)]"]').find('option:checked').val();
    var event_time_minutes = $('select[name="[event_time(5i)]"]').find('option:checked').val();
    var event_time = (Number(event_time_hours) * 60 + Number(event_time_minutes)) * 60;
    $('input[name="event_time"]').val(event_time);
  });
};

  function modal_close(){
    $('span').click();
  };

  function ajax_submit(path){
    // イベント詳細フォーム
    $.ajax({
      type: 'GET',
      url: path,
    });
}