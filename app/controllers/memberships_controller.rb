class MembershipsController < PrivateController
  before_action :set_project

  def index
    @membership = @project.memberships.new
    #@membership = Membership.new
  end

  def create
    @membership = @project.memberships.new(membership_params)
     #@membership = Membership.new(membership_params.merge(project_id: params[:project_id]))
    if @membership.save
      flash[:success] = "#{@membership.user.full_name} was successfully added."
      redirect_to project_memberships_path(@project)
    else
      render :index
    end
  end

  def update
    @membership = Membership.find(params[:id])
    if @membership.update(membership_params)
      flash[:success] = "#{@membership.user.full_name} was successfully updated."
      redirect_to project_memberships_path(@project)
    else
      render :index
    end
  end

  def destroy
    membership = Membership.find(params[:id])
    membership.destroy
    flash[:success] = "#{membership.user.full_name} was successfully removed"
    redirect_to project_memberships_path(@project)
  end

  private

  def set_project
    @project = Project.find(params[:project_id])
  end

  def membership_params
    params.require(:membership).permit(:user_id, :project_id, :role)
  end

end
