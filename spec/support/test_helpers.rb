def sign_in(user = create_user)
  visit root_path
  click_link 'Sign In'
  fill_in :email, with: 'test2@success.com'
  fill_in :password, with: '1234'
  click_button 'Sign in'
end
