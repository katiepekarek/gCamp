require "rails_helper"

describe TasksController do
  let(:user) {create_user}
  let(:project) {create_project}

  before(:each) do
    session[:user_id] = user.id
  end

  describe 'GET #index' do
    it 'renders the index template' do
      task = create_task
      get :index, project_id: project.id
      expect(response).to render_template :index
    end

    it 'redirects a non-signed in user' do
      session.clear
      task = create_task
      get :index, project_id: project.id
      expect(response).to redirect_to sign_in_path
    end
  end

  describe 'GET #show' do
    it 'assigns the correct task to @task'do
      task = create_task
      session[:user_id] = user.id
      get :show, project_id: project.id, id: task.id
      expect(assigns(:task)).to eq task
    end

    it 'renders the task show page' do
      task = create_task
      get :show, project_id: project.id, id: task.id
      expect(response).to render_template :show
    end

    it 'does not render the show page if you are not a member of that project' do
      session.clear
      user = create_user_non_admin
      membership = create_membership(project_id: project.id, user_id: user.id, role: "member")
      project2 = create_project(name: "Re-write American tax code")
      session[:user_id] = user.id
      task = create_task
      get :show, project_id: project2.id, id: task.id
      expect(response).to redirect_to projects_path
    end
  end

  describe 'GET #edit' do
    it 'does not render the page if you are not a member of that project' do
      session.clear
      user = create_user_non_admin
      membership = create_membership(project_id: project.id, user_id: user.id, role: "member")
      project2 = create_project(name: "Re-write American tax code")
      session[:user_id] = user.id
      task = create_task
      get :edit, project_id: project2.id, id: task.id
      expect(response).to redirect_to projects_path
    end

    it 'renders the edit template if you are a member/admin' do
      membership = create_membership(project_id: project.id, user_id: user.id, role: "member")
      task = create_task
      get :edit, project_id: project.id, id: task.id
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    it 'does not allow you to create a task if you are not a member of that project' do
      session.clear
      user = create_user_non_admin
      membership = create_membership(project_id: project.id, user_id: user.id, role: "member")
      project2 = create_project(name: "Re-write American tax code")
      session[:user_id] = user.id
      task = create_task
      expect{post :create, project_id: project2.id, id: task.id}.to_not change {Task.count}
      expect(response).to redirect_to projects_path
    end

    it "saves a task if you are member/admin" do
      membership = create_membership(project_id: project.id, user_id: user.id, role: "member")
      expect{post :create, project_id: project.id, task:{description: 'Floss teeth', due_date: '2016-03-15', completed: false, project_id: project.id}}.to change {Task.count}.by(1)
      expect(response).to redirect_to project_tasks_path(project)
    end
  end

  describe 'PATCH #update' do
    it 'does not allow access if not a project member' do
      session.clear
      user = create_user_non_admin
      membership = create_membership(project_id: project.id, user_id: user.id, role: "member")
      project2 = create_project(name: "Re-write American tax code")
      session[:user_id] = user.id
      task = create_task
      patch :update, project_id: project2.id, id: task.id
      expect(response).to redirect_to projects_path
    end

    it 'updates a task if you are member/admin' do
      project = create_project(name: "Re-write American tax code")
      task = create_task(description: 'Floss teeth', due_date: '2016-03-15', completed: false, project_id: project.id)
      membership = create_membership(project_id: project.id, user_id: user.id, role: "member")
      patch :update, project_id: project.id, id: task.id, task: {description: 'Brush teeth'}
      task.reload
      expect(response).to redirect_to project_tasks_path(project)
      expect(task.description).to eq("Brush teeth")
      expect(flash[:success]).to eq "Task was successfully updated."
    end
  end

  describe 'DELETE #destroy' do
    it 'does not allow acces for non-project members' do
      session.clear
      user = create_user_non_admin
      membership = create_membership(project_id: project.id, user_id: user.id, role: "member")
      project2 = create_project(name: "Re-write American tax code")
      session[:user_id] = user.id
      task = create_task
      delete :destroy, project_id: project2.id, id: task.id
      expect(response).to redirect_to projects_path
      expect(flash[:danger]).to eq('You do not have access to that project')
    end

    it 'allows a member/admin to delete a task' do
      task = create_task
      membership = create_membership(project_id: project.id, user_id: user.id, role: "member")
      expect{delete :destroy, project_id: project.id, id: task.id}.to change(Task, :count).by(-1)
      expect(response).to redirect_to project_tasks_path(project)
      expect(flash[:success]).to eq "Task was successfully deleted."
    end
  end
end
