class PrivateController <ApplicationController
  before_action :authorize
  before_action :set_project

  def set_project
    @project = Project.find(params[:id])
  end
end
