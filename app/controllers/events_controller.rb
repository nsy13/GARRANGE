class EventsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :edit, :update, :destroy]

  def new
    @event = Event.new
    @calendars = current_user.calendars
    if params[:selected_calendars]
      selected_calendars_id = params[:selected_calendars].split(',').map { |cal| cal.slice(/[0-9].*/).to_i }
      @calendar = Calendar.find_by(id: selected_calendars_id[0])
    else
      @calendar = @calendars.first
    end
  end

  def create
    @calendar = Calendar.find(params[:event][:calendar_id])
    @event = Event.new(event_params)
    if @event.save
      @event.user_events.create(user_id: current_user.id, accepted: true)
      @event.calendar_events.create(calendar_id: @calendar.id)
      params[:event][:participants].split(", ").each do |p|
        participant = User.find_by(name: p)
        UserEvent.create(user_id: participant.id, event_id: @event.id)
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
    #FIXME: participantsが存在しない場合にバグ
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

  private

  def event_params
    params.require(:event).permit(:title, :description, :start_date, :end_date, :organizer_id)
  end
end
