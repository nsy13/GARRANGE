class CalendarsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :edit, :update, :destroy]

  def index
    @calendar = Calendar.all
  end

  def new
    @calendar = Calendar.new
  end

  def create
    @calendar = current_user.calendars.build(calendar_params)
    if @calendar.save
      flash[:success] = "カレンダーを作成しました"
      redirect_to root_path
    else
      render 'new'
    end
  end

  def show
    @calendar = Calendar.find(params[:id])
  end

  def edit
    @calendar = Calendar.find(params[:id])
  end

  def update
    @calendar = Calendar.find(params[:id])
    if @calendar.update_attributes(calendar_params)
      flash[:success] = "カレンダー情報を更新しました"
      redirect_to root_path
    else
      render 'edit'
    end
  end

  def destroy
    Calendar.find(params[:id]).destroy
    flash[:success] = "カレンダーを削除しました"
    redirect_to root_path
  end

  private

  def calendar_params
    params.require(:calendar).permit(:name)
  end
end
