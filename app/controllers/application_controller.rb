class ApplicationController < ActionController::Base
  def after_sign_in_path_for(resource)
    root_path
  end

  def after_sign_out_path_for(resource)
    login_path
  end

  protected
  def authenticate_user!
    if user_signed_in?
      super
    else
      flash[:info] = "ログインしてください"
      redirect_to login_path
    end
  end
end
