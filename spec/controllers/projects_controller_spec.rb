require 'rails_helper'

describe ProjectsController do
  let(:user) { create_user }
  let(:no_admin) { create_user_non_admin }


  describe 'GET #index' do
    it 'renders the index page'do
      session[:user_id] = user.id
      get :index
      expect(response).to render_template :index
    end
  end

  describe 'GET #show' do
    it 'assigns the requested project to @project' do
      project = create_project
      session[:user_id] = user.id
      get :show, id: project.id
      expect(assigns(:project)).to eq project
    end

    it 'renders the project show page' do
      project = create_project
      session[:user_id] = user.id
      get :show, id: project.id
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    it 'assisgns a new project to @project' do
      session[:user_id] = user.id
      get :new
      expect(assigns(:project)).to be_a_new(Project)
    end

    it 'renders the new template' do
      session[:user_id] = user.id
      get :new
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    it 'save a new project and creates a new membership' do
      session[:user_id] = user.id
      get :new
      expect { post :create, project: { name: 'Build superfast railway to DIA' }}.to change {Project.count}.from(0).to(1)
      expect(response).to redirect_to project_tasks_path(Project.last)
      expect(Membership.count).to eq(1)
    end

    it 'renders the new template if project id not valid' do
      session[:user_id] = user.id
      post :new
      expect { post :create, project:{name: nil}}.to_not change {Project.count}
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    it 'redirects if a user does not have access to that project' do
      project = create_project
      session[:user_id] = no_admin.id
      get :edit, id: project.id
      expect(response).to redirect_to projects_path
    end

    it 'renders the edit template' do
      user = create_user(first_name: 'Nina', last_name: 'Simone', email: 'blues@singer.com', password: '1234', password_confirmation: '1234', admin: true)
      session[:user_id] = user.id
      project = create_project
      membership = create_membership(project_id: project.id, user_id: user.id, role: "owner")
      get :edit, id: project
      expect(response).to render_template :edit
    end

    it 'redirects if a user is not logged in' do
      project = create_project
      get :edit, id: project
      expect(response.status).to eq 302
      expect(response).to redirect_to sign_in_path
    end
  end

  describe 'PATCH #update' do
    it 'locates the correct project for @project' do
      user = create_user(first_name: 'Nina', last_name: 'Simone', email: 'blues@singer.com', password: '1234', password_confirmation: '1234', admin: false)
      session[:user_id] = user.id
      project = create_project
      membership = create_membership(project_id: project.id, user_id: user.id, role: "owner")
      patch :update, id: project, project: {name: project.name}
      expect(assigns(:project)).to eq project
    end

    it 'updates the correct params if user is admin or project owner' do
      user = create_user(first_name: 'Nina', last_name: 'Simone', email: 'blues@singer.com', password: '1234', password_confirmation: '1234', admin: false)
      session[:user_id] = user.id
      project = create_project
      membership = create_membership(project_id: project.id, user_id: user.id, role: "owner")
      patch :update, id: project, project: {name: 'Book concert'}
      project.reload
      expect(response).to redirect_to project_path(project)
      #expect(flash[:notice]).to eq "Project was successfully updated"
      expect(project.name).to eq ("Book concert")
    end

    it 'redirects if user is not allowed access to the page' do
      user = create_user(first_name: 'Nina', last_name: 'Simone', email: 'blues@singer.com', password: '1234', password_confirmation: '1234', admin: false)
      session[:user_id] = user.id
      project = create_project
      membership = create_membership(project_id: project.id, user_id: user.id, role: "member")
      patch :update, id: project, project: {name: 'Book concert'}
      expect(response).to redirect_to project_path(project)
      #expect(flash[:notice]).to eq "You do not have access"
    end
  end

  describe 'DELETE #destroy' do
    it 'deletes a project' do
      user = create_user(first_name: 'Nina', last_name: 'Simone', email: 'blues@singer.com', password: '1234', password_confirmation: '1234', admin: false)
      session[:user_id] = user.id
      project = create_project
      membership = create_membership(project_id: project.id, user_id: user.id, role: "owner")
      delete :destroy, id: project
      expect(response).to redirect_to projects_path
    end

    it 'redirects if user does not have access' do
      user = create_user(first_name: 'Nina', last_name: 'Simone', email: 'blues@singer.com', password: '1234', password_confirmation: '1234', admin: false)
      session[:user_id] = user.id
      project = create_project
      membership = create_membership(project_id: project.id, user_id: user.id, role: "member")
      delete :destroy, id: project
      expect(response).to redirect_to project_path(project)
    end
  end
end
