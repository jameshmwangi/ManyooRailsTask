class TasksController < ApplicationController
  before_action :require_login
  before_action :set_task, only: %i[show edit update destroy]
  before_action :ensure_correct_user, only: %i[show edit update destroy]

  def index
    @tasks = current_user.tasks

    if params[:search].present?
      if params[:search][:title].present?
        @tasks = @tasks.search_title(params[:search][:title])
      end
      if params[:search][:status].present?
        @tasks = @tasks.search_status(params[:search][:status])
      end
      if params[:search][:label].present?
        @tasks = @tasks.joins(:labels).where(labels: { id: params[:search][:label] }).distinct
      end
    end

    if params[:sort_deadline_on]
      @tasks = @tasks.sort_deadline_on
    elsif params[:sort_priority]
      @tasks = @tasks.sort_priority
    else
      @tasks = @tasks.sort_created_at
    end

    @tasks = @tasks.page(params[:page]).per(10)
  end

  def show
  end

  def new
    @task = Task.new
  end

  def edit
  end

  def create
    @task = current_user.tasks.build(task_params)

    if @task.save
      redirect_to @task, notice: 'タスクを登録しました'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @task.update(task_params)
      redirect_to @task, notice: 'タスクを更新しました'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @task.destroy
    redirect_to tasks_url, notice: 'タスクを削除しました'
  end

  private

  def set_task
    @task = Task.find(params[:id])
  end

  def ensure_correct_user
    unless @task.user_id == current_user.id
      redirect_to tasks_path, notice: 'アクセス権限がありません'
    end
  end

  def task_params
    params.require(:task).permit(:title, :content, :deadline_on, :priority, :status, label_ids: [])
  end
end
