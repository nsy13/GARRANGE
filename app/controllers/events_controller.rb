class EventsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :edit, :update, :destroy]

  def new
    @event = Event.new
    @inviting_users = []
    if params[:event_time]
      @event.start_date = params[:select_date].to_time
      @event.end_date = @event.start_date + params[:event_time].to_i.minutes
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
    @event = Event.find(params[:id])
    @calendar = @event.calendars.first
    @calendars = current_user.calendars
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
    @inviting_members = []
    inviting_id.each do |i_id|
      @inviting_members << User.find_by(id: i_id)
    end
    @calendars = current_user.calendars
  end

  def update
    event = Event.find(params[:id])
    if current_user.id == event.organizer_id
      if event.update_attributes(event_params)
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
    flash[:success] = "イベントへの招待を承認しました"
    redirect_to notifications_index_path
  end

  def absent
    current_user.user_events.find_by(event_id: params[:event_id]).delete
    flash[:warning] = "イベントを欠席しました"
    redirect_to notifications_index_path
  end

  def date_search
    @event = Event.new
    @my_calendars = current_user.user_calendars.select { |uc| uc.owner == true }.map { |owner| owner.calendar }
    @all_users = User.all
    @users = []
    @event_time = 0
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
      preferred_period_start = Time.zone.local(params["preferred_period_start(1i)"].to_i, params["preferred_period_start(2i)"].to_i, params["preferred_period_start(3i)"].to_i, params["preferred_period_start(4i)"].to_i, params["preferred_period_start(5i)"].to_i)
      preferred_period_end = Time.zone.local(params["preferred_period_end(1i)"].to_i, params["preferred_period_end(2i)"].to_i, params["preferred_period_end(3i)"].to_i, params["preferred_period_end(4i)"].to_i, params["preferred_period_end(5i)"].to_i)
      @event_time = ((params["event_time(4i)"].to_i * 60) + (params["event_time(5i)"].to_i)) * 60
      slot_st = preferred_period_start
      slot = (slot_st)..(slot_st + @event_time)
      slot = (slot_st)..(slot_st + @event_time)
      until slot.include?(preferred_period_end)
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
    event_time = event.start_date .. event.end_date
    event_time.overlaps?(slot)
  end

  private

  def event_params
    params.require(:event).permit(:title, :description, :start_date, :end_date, :organizer_id)
  end
end
