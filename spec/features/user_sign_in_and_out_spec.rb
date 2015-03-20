require 'rails_helper'

feature 'Existing User signin flow' do
  scenario 'allows a user to sign in' do
    user = User.new(first_name: 'Charles', last_name: 'Barkley',email: 'test2@success.com', password: '1234', password_confirmation: '1234')
    user.save!

    visit root_path
    expect(page).to have_content 'Your life, organized'

    click_link 'Sign In'
    expect(current_path).to eq '/sign-in'
    expect(page).to have_content 'Sign into gCamp'
    click_button 'Sign in'
    expect(page).to have_content 'Email / Password combination is invalid'

    fill_in 'Email', with: user.email
    fill_in "Password", with: '1234'
    click_button 'Sign in'

    expect(current_path).to eq projects_path
    expect(page).to have_content 'Projects'
    expect(page).to have_content 'You have successfully signed in'

    click_link 'Sign Out'
    expect(current_path).to eq root_path
    expect(page).to have_content 'You have successfully logged out'
    user.destroy!
  end
end
