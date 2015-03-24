require 'rails_helper'

feature 'Existing users can CRUD Projects' do
  xscenario 'index lists all available projects by name' do
    project = Project.new(name: 'create great wall of china')
    project.save!
    membership = Membership.new(name: 'create great wall of china')
    project.save!

    sign_in_user
    expect(page).to have_content 'Charles Barkley'
    click_link 'Projects'
    expect(page).to have_content "create great wall of china"
  end

  xscenario 'user can create new project' do
    sign_in_user
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
    project = Project.new(name: 'create great wall of china')
    project.save!

    sign_in_user
    visit project_path(project)
    expect(page).to have_content("You do not have access to that project")
    expect(current_path).to eq(projects_path)
    end

  xscenario 'user can edit project' do
    project = Project.new(name: 'create great wall of china')
    project.save!

    sign_in_user
    expect(page).to have_content 'Charles Barkley'
    click_link 'Projects'
    click_link 'create great wall of china'
    click_link 'Edit'
    fill_in :project_name, with: 'create great wall of china and fight huns'
    click_button 'Update Project'
    expect(page).to have_content 'create great wall of china and fight huns'
    expect(page).to have_content 'Project was successfully updated'
  end

  xscenario 'user can delete project' do
    project = Project.new(name: 'create great wall of china')
    project.save!

    sign_in_user
    expect(page).to have_content 'Charles Barkley'
    click_link 'Projects'
    click_link 'create great wall of china'
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
