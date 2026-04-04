class ApplicationController < ActionController::Base
  helper_method :current_user, :logged_in?

  private

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def logged_in?
    current_user.present?
  end

  def require_login
    unless logged_in?
      redirect_to new_session_path, notice: 'ログインしてください'
    end
  end

  def require_logout
    if logged_in?
      redirect_to tasks_path, notice: 'ログアウトしてください'
    end
  end

  def require_admin
    unless current_user && current_user.admin?
      redirect_to tasks_path, alert: '管理者以外アクセスできません'
    end
  end
end
