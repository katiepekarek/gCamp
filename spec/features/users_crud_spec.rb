require 'rails_helper'

feature 'users can CRUD Existing Users' do
  scenario 'users can see an index page with a list of users with name and on ly their own email' do
    create_user(first_name: 'Sam', last_name: 'Smith',email: 'grammy_winner@yahoo.com', password: '1234', password_confirmation: '1234')
    user = create_user(first_name: 'Charles', last_name: 'Barkley',email: 'test2@success.com', password: '1234', password_confirmation: '1234')

    sign_in(user)
    expect(page).to have_content 'Charles Barkley'
    click_link "Users"
    expect(page).to have_content 'Sam Smith'
    expect(page).to_not have_content 'grammy_winner@yahoo.com'
    expect(page).to have_content 'test2@success.com'
  end

  scenario 'user can add new user' do
    user = create_user(first_name: 'Charles', last_name: 'Barkley',email: 'test2@success.com', password: '1234', password_confirmation: '1234')

    sign_in(user)
    expect(page).to have_content 'Charles Barkley'
    click_link 'Users'
    click_link 'New User'
    click_button 'Create User'
    expect(page).to have_content 'First name can\'t be blank'
    fill_in :user_first_name, with: 'Katie'
    fill_in :user_last_name, with: 'Couric'
    fill_in :user_email, with: 'former_host@todayshow.com'
    fill_in :user_password, with: '1234'
    fill_in :user_password_confirmation, with: '1234'
    click_button 'Create User'
    expect(page).to have_content 'Katie Couric'

  end

  scenario 'user can edit user' do
    user = create_user(first_name: 'Charles', last_name: 'Barkley',email: 'test2@success.com', password: '1234', password_confirmation: '1234')

    sign_in(user)
    expect(page).to have_content 'Charles Barkley'
    click_link 'Users'
    click_link 'Edit'
    fill_in :user_first_name, with: 'Chuck'
    fill_in :user_password, with: '1234'
    fill_in :user_password_confirmation, with: '1234'
    click_button 'Update User'
    expect(page).to have_content 'Chuck Barkley'

  end

  scenario 'user can delete user' do
    user = create_user(first_name: 'Charles', last_name: 'Barkley',email: 'test2@success.com', password: '1234', password_confirmation: '1234')

    sign_in(user)
    expect(page).to have_content 'Charles Barkley'
    click_link 'Users'
    click_link 'Edit'
    expect(page).to have_content 'Edit User'
    click_link 'Delete'
    expect(current_path).to eq signin_path

  end
end

feature 'Users who are not signed in can not see Users page' do
  scenario 'user tries to see users page and is redirected to sign_in page' do
    visit users_path
    expect(page).to have_content 'You must sign in'
  end
end
