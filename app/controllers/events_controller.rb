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
    @event = @calendar.events.build(event_params)
    if @event.save
      @event.user_events.create(user_id: current_user.id)
      flash[:success] = "イベントを追加しました"
      redirect_to root_path
    else
      flash[:danger] = "イベントの作成に失敗しました"
      redirect_to root_path
    end
  end

  def edit
    @event = Event.find(params[:id])
  end

  def show
    @event = Event.find(params[:id])
  end

  def update
    @event = Event.find(params[:id])
    if @event.update_attributes(event_params)
      flash[:success] = "イベント情報を更新しました"
      redirect_to root_path
    else
      render 'edit'
    end
  end

  def destroy
    Event.find(params[:id]).destroy
    flash[:success] = "イベントを削除しました"
    redirect_to root_path
  end

  private

  def event_params
    params.require(:event).permit(:title, :description, :start_date, :end_date, :organizer_id)
  end
end
