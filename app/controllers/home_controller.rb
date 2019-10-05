class HomeController < ApplicationController
  before_action :authenticate_user!

  def index
    #TODO: 共有したカレンダーの表示機能も実装
    #TODO: カレンダー、イベントをid順に並べる
    @calendars = current_user.calendars
    @events = current_user.calendars.map { |c| c.events }
    @display_events = @events.flatten #FIXME: jbuilder 向けの暫定対応
  end
end
