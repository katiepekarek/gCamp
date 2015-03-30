require 'rails_helper'

feature 'Existing users can CRUD Projects' do
  scenario 'index lists all available projects where user has a membership by name' do
    project = create_project(name: 'create great wall of china')
    user = create_user(first_name: 'Charles', last_name: 'Barkley',email: 'test2@success.com', password: '1234', password_confirmation: '1234')
    Membership.create!(user_id: user.id, project_id: project.id, role:"owner")

    sign_in(user)
    expect(page).to have_content 'Charles Barkley'
    click_link 'Projects'
    expect(page).to have_content "create great wall of china"
  end

  scenario 'user can create new project' do
    user = create_user(first_name: 'Charles', last_name: 'Barkley',email: 'test2@success.com', password: '1234', password_confirmation: '1234')

    sign_in(user)
    expect(page).to have_content 'Charles Barkley'
    click_link 'Projects'
    expect(page).to have_content "Home"
    page.find(".btn-info").click
    click_button 'Create Project'
    expect(page).to have_content 'Name can\'t be blank'

    fill_in :project_name, with: 'Find Fountain of Youth'
    click_button 'Create Project'

    expect(page).to have_content 'Find Fountain of Youth'
    expect(page).to have_content 'Project was successfully created'
  end

  scenario 'Non-members cannot access projects' do
    project = create_project(name: 'create great wall of china')
    user = create_user(first_name: 'Charles', last_name: 'Barkley',email: 'test2@success.com', password: '1234', password_confirmation: '1234', admin: false)

    sign_in(user)
    visit project_path(project)
    expect(page).to have_content("You do not have access to that project")
    expect(current_path).to eq(projects_path)
    end

  scenario 'owner can edit project' do
    project = create_project(name: 'create great wall of china')
    user = create_user(first_name: 'Charles', last_name: 'Barkley',email: 'test2@success.com', password: '1234', password_confirmation: '1234')
    Membership.create!(user_id: user.id, project_id: project.id, role:"owner")

    sign_in(user)
    expect(page).to have_content 'Charles Barkley'
    click_link 'Projects'
    within '.dropdown' do
      click_link 'create great wall of china'
    end
    click_link 'Edit'
    fill_in :project_name, with: 'create great wall of china and fight huns'
    click_button 'Update Project'
    expect(page).to have_content 'create great wall of china and fight huns'
    expect(page).to have_content 'Project was successfully updated'
  end

  scenario 'project owner can delete project' do
    project = create_project(name: 'create great wall of china')
    user = create_user(first_name: 'Charles', last_name: 'Barkley',email: 'test2@success.com', password: '1234', password_confirmation: '1234')
    Membership.create!(user_id: user.id, project_id: project.id, role:"owner")

    sign_in(user)
    expect(page).to have_content 'Charles Barkley'
    click_link 'Projects'
    within '.dropdown' do
      click_link 'create great wall of china'
    end
    click_link 'Delete'
    expect(page).to have_content 'Project was successfully deleted'
  end
end

feature 'Users who are not signed in can not see Projects page' do
  scenario 'user tries to see projects page and is redirected to sign_in page' do
  visit projects_path
  expect(page).to have_content 'You must sign in'
  end
end
