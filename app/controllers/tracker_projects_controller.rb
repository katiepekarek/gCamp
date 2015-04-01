class TrackerProjectsController <PrivateController
  skip_before_action :set_project
  def show
    tracker_api = TrackerAPI.new
    if current_user.pivotal_tracker_token
      @tracker_stories = tracker_api.stories(current_user.pivotal_tracker_token, params[:id])
      @tracker_project = params[:project_name]
    end
  end
end
