class MembershipsController < PrivateController
  before_action :set_project
  before_action :member_auth

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
    if @project.memberships.where(role: "owner").count > 1
      @membership.update(membership_params)
      flash[:success] = "#{@membership.user.full_name} was successfully updated."
      redirect_to project_memberships_path(@project)
    else
      flash[:danger] = "Projects must have at least one owner"
      render :index
    end
  end

  def destroy
    @membership = @project.memberships.find(params[:id])
    if @project.memberships.where(role: "owner").count > 1
      membership.destroy
      flash[:success] = "#{membership.user.full_name} was successfully removed"
      redirect_to project_memberships_path(@project)
    else
      flash[:danger] = "Projects must have at least one owner"
      redirect_to project_memberships_path(@project)
    end
  end

  private

  def set_project
    @project = Project.find(params[:project_id])
  end

  def membership_params
    params.require(:membership).permit(:user_id, :project_id, :role)
  end

end
