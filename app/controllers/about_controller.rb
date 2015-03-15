class AboutController <ApplicationController
  def index
    @projects = Project.all
    @users = User.all
    @tasks = Task.all
    @memberships = Membership.all
    @comments = Comment.all
  end
end
