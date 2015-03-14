class AboutController <ApplicationController
  def index
    @projects = Project.all
    @users = User.all
    @tasks = Task.all
  end
end
