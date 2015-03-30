require "rails_helper"

describe UsersController do
  describe "GET #index" do
    it "renders the index template" do
      user = create_user
      session[:user_id] = user.id
      get :index
      expect(response).to render_template("index")
    end
  end

  describe "GET #show" do
    it "assigns the requested user to @user" do
      user = create_user(first_name: 'Charles', last_name: 'Barkley',email: 'test2@success.com', password: '1234', password_confirmation: '1234')
      session[:user_id] = user.id
      get :show, id: user
      expect(assigns(:user)).to eq user
    end

    it "renders the user show page" do
      user = create_user(first_name: 'Charles', last_name: 'Barkley',email: 'test2@success.com', password: '1234', password_confirmation: '1234')
      session[:user_id] = user.id
      get :show, id: user
      expect(response).to render_template :show
    end
  end

  describe 'GET #new' do
    it 'assigns a new user to @user' do
      user = create_user
      session[:user_id] = user.id
      get :new
      expect(assigns(:user)).to be_a_new(User)
    end
    it 'renders the new template' do
      user = create_user(first_name: 'Charles', last_name: 'Barkley',email: 'test2@success.com', password: '1234', password_confirmation: '1234')
      session[:user_id] = user.id
      get :new
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    it 'saves a new user' do
      user = create_user
      session[:user_id] = user.id
      post :new
      expect { post :create, user: { first_name: "Mark", last_name: "Price", email: "25@yahoo.com", password: "1234" }}.to change {User.all.count}.by(1)
      expect(response).to redirect_to users_path

    end
    it 'renders new if user is not valid' do
      user = create_user
      session[:user_id] = user.id
      post :new
      expect { post :create, user:{first_name: nil, last_name: "Smith", email: nil, password: "1234"}}.to_not change {User.all.count}
      expect(response).to render_template :new
    end
  end

  describe 'GET #edit' do
    it 'redirects if a user is not logged in' do
      user = create_user(first_name: 'Charles', last_name: 'Barkley',email: 'test2@success.com', password: '1234', password_confirmation: '1234')
      get :edit, id: user
      expect(response.status).to eq 302
      expect(response).to redirect_to sign_in_path
    end

    it 'renders 404 if a logged in user trys to access an edit page that is not theirs and they are not admin' do
      user = create_user(first_name: 'Charles', last_name: 'Barkley',email: 'test2@success.com', password: '1234', password_confirmation: '1234', admin: false)
      user2 = create_user(first_name: "James", last_name: "Brown", email: "1234@yahoo.com", password: "1234", password_confirmation: "1234" )
      session[:user_id] = user.id
      get :edit, id: user2
      expect(response.status).to eq 404
    end
  end

  describe 'PATCH #update'do
    it 'locates the correct @user' do
      user = create_user
      session[:user_id] = user.id
      patch :update, id: user, user: {first_name: user.first_name, last_name: user.last_name, email: user.email}
      expect(assigns(:user)).to eq user
    end

    it 'updates the correct users params when the user is an admin or the user' do
      user = create_user
      session[:user_id] = user.id
      patch :update, id: user, user: {first_name: "Jim", last_name: "Thome", email: "test2@success.com", password: "1234"}
      user.reload
      expect(user.first_name).to eq("Jim")
      expect(user.last_name).to eq("Thome")
      expect(user.email).to eq("test2@success.com")
      expect(response).to redirect_to user_path(user)
    end

    it 'renders 404 if a user tries to update a user that is not theirs and they are not an admin' do
      user = create_user(first_name: "Tim", last_name: "Horton", email: "hearsawhoo@yahoo.com", password: "1234", password_confirmation: "1234", admin: false )
      user2 = create_user(first_name: "James", last_name: "Brown", email: "1234@yahoo.com", password: "1234", password_confirmation: "1234", admin: false )
      session[:user_id] = user.id
      patch :update, id: user2.id, user:{first_name: "bob"}
      expect(response.status).to eq 404
    end
  end

  describe 'DELETE #destroy' do
    it 'deletes a user'do
      user = create_user
      session[:user_id] = user.id
      expect{delete :destroy, id: user}.to change(User,:count).by(-1)
      expect(response).to redirect_to users_path
    end

    it 'renders a 404 if a user tries to delete a user that is not theirs' do
      user = create_user(first_name: "Tim", last_name: "Horton", email: "hearsawhoo@yahoo.com", password: "1234", password_confirmation: "1234", admin: false )
      user2 = create_user(first_name: "James", last_name: "Brown", email: "1234@yahoo.com", password: "1234", password_confirmation: "1234" )
      session[:user_id] = user.id
      delete :destroy, id: user2
      expect(response.status).to eq 404
    end

    it "allows an admin to delete any user" do
      user = create_user
      user2 = create_user(first_name: "James", last_name: "Brown", email: "1234@yahoo.com", password: "1234", password_confirmation: "1234" )
      session[:user_id] = user.id
      delete :destroy, id: user2
      expect(response).to redirect_to users_path
    end
  end

end
