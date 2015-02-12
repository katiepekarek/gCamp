class TasksController < ApplicationController
  respond_to :html, :xml, :js
  before_action :set_task, only: [:show, :edit, :update, :destroy]

  def index
    @tasks = Task.all
  end

  def show
    @task = Task.find(params[:id])
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)

    if @task.save
      flash[:success] = "Task was successfully created."

      respond_with(@task) do |format|
      format.html { render }
      end

    end
  end

  def edit
  end

  def update
    @task = Task.find(params[:id])

    if @task.update(task_params)
      flash[:success] = "Task was successfully updated."

      redirect_to tasks_path

    else
      render :edit
    end
  end

  def destroy
    @task.destroy

    redirect_to tasks_path
  end

  private

  def set_task
    @task = Task.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:description, :completed)
  end

end
