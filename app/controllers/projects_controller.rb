class ProjectsController <ApplicationController
  def index
    @projects = Project.all
  end

  def new
    @project = Project.new
  end

  def create
    project = Project.new(project_params)
    if project.save
  

      redirect_to projects_path
    end
  end

  def show
    @project = Project.find(params[:id])
  end

  def edit
    @project = Project.find(params[:id])
  end

  def update
    @project = Project.find(params[:id])
    if @project.update(project_params)
      flash[:success] = 'Project was successfully updated'

      redirect_to project_path
    else
      render :edit
    end
  end

  def destroy
    @project = Project.find(params[:id])
    if @project.destroy
      flash[:delete] = 'Project was successfully deleted'

      redirect_to project_path
    end
  end

  private

  def project_params
    params.require(:project).permit(:name)
  end

end
