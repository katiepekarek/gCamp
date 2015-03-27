class TasksController <PrivateController
  before_action :authorize
  before_action :set_project
  before_action :member_or_admin_auth

  def index
    @tasks = @project.tasks
  end

  def show
    @task = Task.find(params[:id])
    @comment = Comment.new
  end

  def new
    @task = @project.tasks.new
  end

  def create
    @task = @project.tasks.new(task_params)

    if @task.save
      flash[:success] = "Task was successfully created."

      redirect_to project_tasks_path(@project)
    else
      render :new
    end
  end

  def edit
    @task = Task.find(params[:id])
  end

  def update
    @task = @project.tasks.find(params[:id])

    if @task.update(task_params)
      flash[:success] = "Task was successfully updated."

      redirect_to project_tasks_path(@project)

    else
      render :edit
    end
  end

  def destroy
    Task.find(params[:id]).destroy
    flash[:success] = "Task was successfully deleted."
    redirect_to project_tasks_path(@project)
  end

  private

  def task_params
    params.require(:task).permit(:description, :completed, :due_date, :project_id)
  end

  def set_project
    @project = Project.find(params[:project_id])
  end

end
