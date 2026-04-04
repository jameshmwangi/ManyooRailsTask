class SessionsController < ApplicationController
  before_action :forbid_login_user, only: [:new, :create]

  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      session[:user_id] = user.id
      redirect_to tasks_path, notice: 'ログインしました'
    else
      flash.now[:alert] = 'メールアドレスまたはパスワードに誤りがあります'
      render :new
    end
  end

  def destroy
    session.delete(:user_id)
    redirect_to new_session_path, notice: 'ログアウトしました'
  end

  private

  def forbid_login_user
    if logged_in?
      redirect_to tasks_path, notice: 'ログアウトしてください'
    end
  end
end
