require "rails_helper"

describe TasksController do
  let(:user) {create_user}
  let(:project) {create_project}

  before(:each) do
    session[:user_id] = user.id
  end

end
