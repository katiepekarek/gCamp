class TasksController < ApplicationController

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

      redirect_to task_path(@task)
    else
      render :new
    end
  end

  def edit
    @task = Task.find(params[:id])
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
    Task.find(params[:id]).destroy

    redirect_to tasks_path
  end

  private

  def task_params
    params.require(:task).permit(:description, :completed, :due_date)
  end

end
