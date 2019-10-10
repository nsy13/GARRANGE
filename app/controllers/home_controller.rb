class HomeController < ApplicationController
  before_action :authenticate_user!, only: [:index]

  def index
    @user = User.find_by(id: params[:user_id]) || current_user
    user_calendars = @user.user_calendars
    @my_calendars = user_calendars.select { |uc| uc.owner == true }.map { |owner| owner.calendar }
    @others_calendars = user_calendars.select { |oc| oc.owner == false }.map { |others| others.calendar }
    if params[:selected_calendars]
      selected_calendars_id = params[:selected_calendars].split(',').map { |cal| cal.slice(/[0-9].*/).to_i }
      if selected_calendars_id.include?(0)
        events = []
      else
        calendars = selected_calendars_id.map { |id| Calendar.find(id) }
        events = calendars.map { |calendar| calendar.events }
      end
      @display_events = events.flatten
    else
      # @events = @user.calendars.order(id: "ASC").map { |calendar| calendar.events }
      @display_events = @my_calendars.first.events
    end
  end
end
