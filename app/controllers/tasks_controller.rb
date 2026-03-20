class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]

  def index
    # Fetches tasks in descending order, paginated, 10 per page
    @tasks = Task.order(created_at: :desc).page(params[:page]).per(10)
  end

  def show
  end

  def new
    @task = Task.new
  end

  def edit
  end

  def create
    @task = Task.new(task_params)
    if @task.save
      redirect_to tasks_path, notice: t('flash.tasks.create')
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @task.update(task_params)
      redirect_to @task, notice: t('flash.tasks.update')
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @task.destroy
    redirect_to tasks_url, notice: t('flash.tasks.destroy')
  end

  private

  def set_task
    @task = Task.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:title, :content)
  end
end
