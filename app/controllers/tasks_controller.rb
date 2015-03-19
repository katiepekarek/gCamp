class TasksController <PrivateController
  before_action :authorize

  def index
    @project = Project.find(params[:project_id])
    @tasks = @project.tasks
  end

  def show
    @project = Project.find(params[:project_id])
    @task = Task.find(params[:id])
    @comment = Comment.new
  end

  def new
    @project = Project.find(params[:project_id])
    @task = @project.tasks.new
  end

  def create
    @project = Project.find(params[:project_id])
    @task = @project.tasks.new(task_params)

    if @task.save
      flash[:success] = "Task was successfully created."

      redirect_to project_tasks_path(@project, @task)
    else
      render :new
    end
  end

  def edit
    @project = Project.find(params[:project_id])
    @task = Task.find(params[:id])
  end

  def update
    @project = Project.find(params[:project_id])
    @task = @project.tasks.find(params[:id])

    if @task.update(task_params)
      flash[:success] = "Task was successfully updated."

      redirect_to project_tasks_path(@project, @task)

    else
      render :edit
    end
  end

  def destroy
    @project = Project.find(params[:project_id])
    Task.find(params[:id]).destroy
    flash[:success] = "Task was successfully deleted."
    redirect_to project_tasks_path(@project)
  end

  private

  def task_params
    params.require(:task).permit(:description, :completed, :due_date, :project_id)
  end

end
