class HomeController < ApplicationController
  before_action :authenticate_user!

  def index
    #TODO: 共有したカレンダーの表示機能も実装
    @calendars = current_user.calendars
    @events = current_user.calendars.flat_map { |c| c.events }
  end
end
