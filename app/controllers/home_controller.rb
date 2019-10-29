class HomeController < ApplicationController
  before_action :authenticate_user!, only: [:settings]

  def index
    if user_signed_in?
      @user = User.find_by(id: params[:user_id]) || current_user
      user_calendars = @user.user_calendars
      @my_calendars = user_calendars.select { |uc| uc.owner == true }.map { |owner| owner.calendar }
      @others_calendars = user_calendars.select { |oc| oc.owner == false }.map { |others| others.calendar }
      @accessed_calendars = @others_calendars && UserCalendar.where(user_id: current_user.id).map { |user_calendar| user_calendar.calendar }
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
        @display_events = @my_calendars.first.events
      end
      @q = User.ransack(params[:q])
      @searched_users = nil
    end
  end

  def about
  end

  def search_user
    @q = User.ransack(params[:q])
    if params[:q][:name_or_email_cont].blank?
      @searched_users = nil
    elsif params[:q][:name_or_email_cont]
      @searched_users = @q.result(distinct: true)
    else
      @searched_users = []
    end
  end
end
