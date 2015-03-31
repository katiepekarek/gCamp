class MembershipsController < PrivateController
  before_action :set_membership, except: [:index, :create]
  before_action :verify_ownership, only: [:update, :destroy]
  before_action :member_or_admin_auth, except: [:destroy]
  before_action :project_owner_or_admin, except: [:index, :destroy]
  before_action :project_owner_or_admin_or_member, only: [:destroy]

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
    if @membership.update(membership_params)
      flash[:success] = "#{@membership.user.full_name} was successfully updated."
      redirect_to project_memberships_path(@project)
    else
      render :index
    end
  end

  def destroy
    if @membership.destroy
      flash[:success] = "#{@membership.user.full_name} was successfully removed"
      redirect_to projects_path
    end
  end

  private

  def set_project
    @project = Project.find(params[:project_id])
  end

  def set_membership
    @membership = Membership.find(params[:id])
  end

  def membership_params
    params.require(:membership).permit(:user_id, :project_id, :role)
  end

end
