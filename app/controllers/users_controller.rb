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
      redirect_to tasks_path, notice: "I have registered an account "
    else
      render :new , status: :unprocessable_entity
    end
  end

  def show
  end

  def edit
  end
end

  def update
    if @user.update(user_params)
      redirect_to tasks_path, notice: "Your account has been updated "
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def ensure_correct_user
    if logged_in?
      redirect_to tasks_path, alert: "You do not have permission to access"
    end
  end
end
