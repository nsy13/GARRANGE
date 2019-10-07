class HomeController < ApplicationController
  before_action :authenticate_user!

  def index
    #TODO: 共有したカレンダーの表示機能も実装
    #TODO: カレンダー、イベントをid順に並べる
    @calendars = current_user.calendars
    if params[:selected_calendars]
      selected_calendars_id = params[:selected_calendars].split(',').map { |cal| cal.slice(/[0-9].*/).to_i }
      if selected_calendars_id.include?(0)
        @events = []
      else
        calendars = selected_calendars_id.map { |id| Calendar.find(id) }
        @events = calendars.map { |calendar| calendar.events }
      end
      @display_events = @events.flatten
    else
      @events = current_user.calendars.map { |calendar| calendar.events }
      @display_events = @events.first
    end
  end
end
