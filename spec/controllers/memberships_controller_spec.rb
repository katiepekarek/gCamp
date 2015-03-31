require 'rails_helper'

describe MembershipsController do
  let(:user) {create_user}
  let(:project) {create_project}
  before(:each) do
    session[:user_id] = user.id
  end

  describe 'GET #index' do
    it 'renders the index template' do
      session[:user_id] = user.id
      get :index, project_id: project.id
      expect(response).to render_template :index
    end
  end

  describe 'POST #create' do
    it 'saves a new membership if user is admin' do
      session.clear
      user1 = create_user(first_name: "Katie", last_name: "Couric", email: "todayshow@yahoo.com", password: "1234", password_confirmation: "1234" )
      session[:user_id] = user1.id
      project = create_project
      membership = create_membership(user_id: user1.id, project_id: project.id, role: "owner")
      user2 = create_user(first_name: "James", last_name: "Brown", email: "soulsinger@yahoo.com", password: "1234", password_confirmation: "1234" )
      expect { post :create, project_id: project.id, membership:{project_id: project.id, user_id: user2.id, role: "member"}}.to change {Membership.count}.by(1)
      expect(response).to redirect_to project_memberships_path(project)
    end

    it 'only allows admins to create membership' do
      membership = create_membership(user_id: user.id, project_id: project.id, role: "owner")
      user2 = create_user(first_name: "James", last_name: "Brown", email: "soulsinger@yahoo.com", password: "1234", password_confirmation: "1234" )
      expect { post :create, project_id: project.id, membership:{project_id: project.id, user_id: user2.id, role: "member"}}.to change {Membership.count}.by(1)
      expect(response).to redirect_to project_memberships_path(project)
    end

    it 'does not allow non-owners/admins to create membership' do
      session.clear
      user = create_user_non_admin
      session[:user_id] = user.id
      project = create_project
      membership = create_membership(project_id: project.id, user_id: user.id, role: 'member')
      expect { post :create, project_id: project.id, membership:{project_id: project.id, user_id: user.id, role: "member"}}.to_not change {Membership.count}
      redirect_to projects_path
    end
  end

  describe 'PATCH #update' do
    it 'does not allow the last owner to be updated' do
      session.clear
      user = create_user_non_admin
      session[:user_id] = user.id
      project = create_project
      membership = create_membership(project_id: project.id, user_id: user.id, role: 'owner')
      patch :update, project_id: project.id, id: membership.id, membership: {role: "member"}
      expect(response).to redirect_to project_memberships_path(project)
    end

    it 'allows owners to update members' do
      membership = create_membership(user_id: user.id, project_id: project.id, role: "owner")
      user2 = create_user(first_name: "James", last_name: "Brown", email: "soulsinger@yahoo.com", password: "1234", password_confirmation: "1234" )
      membership2 = create_membership(project_id: project.id, user_id: user2.id, role: 'member')
      patch :update, project_id: project.id, id: membership2.id, membership: {role: "owner"}
      expect(response).to redirect_to project_memberships_path(project)
    end

    it 'allows admin to update members' do
      membership = create_membership(user_id: user.id, project_id: project.id, role: "member")
      user2 = create_user(first_name: "James", last_name: "Brown", email: "soulsinger@yahoo.com", password: "1234", password_confirmation: "1234" )
      membership2 = create_membership(project_id: project.id, user_id: user2.id, role: 'member')
      patch :update, project_id: project.id, id: membership2.id, membership: {role: "owner"}
      expect(response).to redirect_to project_memberships_path(project)
    end
  end

  describe 'DELETE #destroy' do
    it 'does not allow the last owner to be deleted' do
      session.clear
      user = create_user_non_admin
      session[:user_id] = user.id
      project = create_project
      membership = create_membership(project_id: project.id, user_id: user.id, role: 'owner')
      expect{delete :destroy, project_id: project.id, id: membership.id}.to_not change(Membership,:count)
      expect(response).to redirect_to project_memberships_path(project)
    end

    it 'allows a member to delete themselves' do
      session.clear
      user = create_user_non_admin
      session[:user_id] = user.id
      project = create_project
      membership = create_membership(project_id: project.id, user_id: user.id, role: 'member')
      expect{delete :destroy, project_id: project.id, id: membership.id}.to change(Membership,:count).by(-1)
      expect(response).to redirect_to projects_path
    end

    it 'allows owner/admin to delete a member' do
      membership = create_membership(user_id: user.id, project_id: project.id, role: "member")
      user2 = create_user(first_name: "James", last_name: "Brown", email: "soulsinger@yahoo.com", password: "1234", password_confirmation: "1234" )
      membership2 = create_membership(project_id: project.id, user_id: user2.id, role: 'member')
      expect{delete :destroy, project_id: project.id, id: membership2.id}.to change(Membership, :count).by(-1)
      expect(response).to redirect_to projects_path
    end
  end
end
