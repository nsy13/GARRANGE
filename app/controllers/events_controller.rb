class EventsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :edit, :update, :destroy]

  def index
    @events = Event.all
  end

  def new
    @event = Event.new
  end

  def create
    # TODO: トップページ等からカレンダーを選択してイベントを作成できるように修正
    # TODO: イベントとユーザーの紐付けも追加する user_id = current_user.idとか
    @calendar = Calendar.find(params[:id])
    @event = @calendar.events.build(event_params)
    if @event.save
      flash[:success] = "イベントを追加しました"
      redirect_to root_path
    else
      render 'new'
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
