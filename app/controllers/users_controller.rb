class UsersController < ApplicationController
  before_action :authenticate_user!

  def edit
    @user = current_user
  end

  def update_password
    @user = current_user
    if @user.update_with_password(user_params)
      bypass_sign_in(@user)
      flash[:success] = "パスワードを変更しました"
      redirect_to root_path
    else
      flash[:alert] = "入力に誤りがあります"
      redirect_to setting_profile_path
    end
  end

  private

  def user_params
    params.require(:user).permit(:password, :current_password)
  end
end
