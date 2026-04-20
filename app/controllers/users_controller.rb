class UsersController < ApplicationController
  before_action :require_login, only: [:show, :edit, :update]
  before_action :ensure_correct_user, only: [:show, :edit, :update]
  before_action :forbid_login_user, only: [:new, :create]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to tasks_path, notice: 'アカウントを登録しました'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to user_path(@user), notice: 'アカウントを更新しました'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def ensure_correct_user
    @user = User.find(params[:id])
    unless @user == current_user
      redirect_to tasks_path, notice: 'アクセス権限がありません'
    end
  end

  def forbid_login_user
    if logged_in?
      redirect_to tasks_path, notice: 'ログアウトしてください'
    end
  end
end
