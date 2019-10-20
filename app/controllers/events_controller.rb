class EventsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :edit, :update, :destroy]

  def new
    @event = Event.new
    @inviting_users = []
    if params[:event_time]
      @event.start_date = params[:select_date].to_time
      @event.end_date = @event.start_date + params[:event_time].to_i.seconds
      params[:inviting_users].split(", ").each do |id|
        invited = User.find_by(id: id)
        @inviting_users << invited
      end
    end
    @my_calendars = current_user.user_calendars.select { |uc| uc.owner == true }.map { |owner| owner.calendar }
    @all_users = User.all
    if params[:selected_calendars]
      selected_calendars_id = params[:selected_calendars].split(',').map { |cal| cal.slice(/[0-9].*/).to_i }
      @calendar = Calendar.find_by(id: selected_calendars_id[0])
    else
      @calendar = @my_calendars.first
    end
  end

  def create
    @calendar = Calendar.find(params[:event][:calendar_id])
    @event = Event.new(event_params)
    if @event.save
      @event.user_events.create(user_id: current_user.id, accepted: true)
      @event.calendar_events.create(calendar_id: @calendar.id)
      params[:inviting_users].split(", ").each do |id|
        invited = User.find_by(id: id)
        UserEvent.create(user_id: invited.id, event_id: @event.id)
      end
      flash[:success] = "イベントを追加しました"
      redirect_to root_path
    else
      flash[:danger] = "イベントの作成に失敗しました"
      redirect_to root_path
    end
  end

  def edit
    @all_users = User.all
    @event = Event.find(params[:id])
    @calendar = @event.calendars.first
    @my_calendars = current_user.user_calendars.select { |uc| uc.owner == true }.map { |owner| owner.calendar }
    @participants_inviting_users = []
    participants_inviting_users_id = @event.user_events.map(&:user_id)
    participants_inviting_users_id.each do |id|
      @participants_inviting_users << User.find_by(id: id)
    end
  end

  def show
    # FIXME: participantsが存在しない場合にバグ
    @event = Event.find(params[:id])
    @organizer = User.find_by(id: @event.organizer_id)
    @participants = []
    participants_id = @event.user_events.where(accepted: true).map(&:user_id)
    participants_id.each do |p_id|
      @participants << User.find_by(id: p_id)
    end
    inviting_id = @event.user_events.where(accepted: false).map(&:user_id)
    @inviting_users = []
    inviting_id.each do |i_id|
      @inviting_users << User.find_by(id: i_id)
    end
    @my_calendars = current_user.user_calendars.select { |uc| uc.owner == true }.map { |owner| owner.calendar }
  end

  def update
    event = Event.find(params[:id])
    if current_user.id == event.organizer_id
      if event.update_attributes(event_params)
        participants_inviting_users = []
        participants_inviting_users_id = event.user_events.map(&:user_id)
        participants_inviting_users_id.each do |id|
          participants_inviting_users << User.find_by(id: id)
        end
        params[:inviting_users].split(", ").each do |id|
          invited = User.find_by(id: id)
          unless UserEvent.find_by(user_id: invited.id, event_id: event.id)
            UserEvent.create(user_id: invited.id, event_id: event.id)
          end
          participants_inviting_users.each do |event_member|
            unless event_member == invited
              UserEvent.find_by(user_id: event_member.id, event_id: event.id).delete
            end
          end
        end
        flash[:success] = "イベント情報を更新しました"
        redirect_to root_path
      else
        render 'edit'
      end
    else
      current_user.user_events.find_by(event_id: params[:event][:id]).update_attributes(accepted: true)
      CalendarEvent.create(calendar_id: params[:event][:calendar_id], event_id: params[:event][:id])
      flash[:success] = "イベントを追加しました"
      redirect_to root_path
    end
  end

  def destroy
    Event.find(params[:id]).destroy
    flash[:success] = "イベントを削除しました"
    redirect_to root_path
  end

  def accept
    current_user.user_events.find_by(event_id: params[:event_id]).update_attributes(accepted: true)
    CalendarEvent.create(calendar_id: params[:calendar_id], event_id: params[:event_id])
    flash[:success] = "イベントへの招待を承認しました"
    redirect_to root_path
  end

  def absent
    current_user.user_events.find_by(event_id: params[:event_id]).delete
    flash[:warning] = "イベントを欠席しました"
    redirect_to root_path
  end

  def date_search
    @event = Event.new
    @my_calendars = current_user.user_calendars.select { |uc| uc.owner == true }.map { |owner| owner.calendar }
    @all_users = User.all
    @users = []
    @event_time = 1800
    if params[:selected_calendars]
      selected_calendars_id = params[:selected_calendars].split(',').map { |cal| cal.slice(/[0-9].*/).to_i }
      @calendar = Calendar.find_by(id: selected_calendars_id[0])
    else
      @calendar = @my_calendars.first
    end
    if params[:inviting_users]
      params[:inviting_users].split(", ").each do |id|
        invited = User.find_by(id: id)
        @users << invited
      end
      @users << current_user
      @candidate_dates = []
      preferred_period_start = params[:start_date].in_time_zone
      preferred_period_end = params[:end_date].in_time_zone
      @event_time = params[:event_time].to_i
      slot_st = preferred_period_start
      slot = (slot_st)..(slot_st + @event_time)
      slot = (slot_st)..(slot_st + @event_time)
      until slot.include?(preferred_period_end + 1.minute)
        if @users.all? { |user| user.events.none? { |event| include_slot?(event, slot) } }
          @candidate_dates << slot
        end
        slot_st += 30.minutes
        slot = slot_st .. slot_st + @event_time
        slot = slot_st .. slot_st + @event_time
        break if @candidate_dates.size == 3
      end
    end
  end

  def include_slot?(event, slot)
    event_time = (event.start_date + 1.minute) .. (event.end_date - 1.minute)
    event_time.overlaps?(slot)
  end

  private

  def event_params
    params.require(:event).permit(:title, :description, :start_date, :end_date, :organizer_id)
  end
end
