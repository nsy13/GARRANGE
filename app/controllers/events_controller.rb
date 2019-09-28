class EventsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :edit, :update, :destroy]

  def index
    @events = Event.all
  end

  def create
    # FIXME: if 文で代入するのはよくない
    if @event = current_user.events.create(event_params)
      # TODO: flash 機能追加
      # flash[:success] = "イベントを追加しました"
      redirect_to @event
    else
      # flash[:danger] = "イベントを作成できませんでした"
      render 'new'
    end
  end

  def new
    @event = Event.new
  end

  def edit
  end

  def show
    @event = Event.find_by(id: params[:id])
  end

  def update
  end

  def destroy
  end

  private

  def event_params
    params.require(:event).permit(:title, :description, :start_date, :end_date)
  end
end
