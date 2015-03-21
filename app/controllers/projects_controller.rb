class ProjectsController <PrivateController
  before_action :authorize

  def index
    @projects = Project.all
  end

  def new
    @project = Project.new
  end

  def create
    @project = Project.new(project_params)
    if @project.save
      flash[:success] = 'Project was successfully created'
      Membership.create(:project_id => @project.id, :user_id => current_user.id, :role => 'owner')
      redirect_to project_path(@project)
    else
      render :new
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

      redirect_to project_path(@project)
    else
      render :edit
    end
  end

  def destroy
    Project.find(params[:id]).destroy
      flash[:success] = 'Project was successfully deleted'

      redirect_to projects_path

  end

  private

  def project_params
    params.require(:project).permit(:name)
  end

end
