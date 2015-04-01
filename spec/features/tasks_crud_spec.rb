require 'rails_helper'

feature 'Existing users CRUD tasks within projects' do
  scenario 'project owner index lists all available tasks with description, due_date' do
    project = create_project(name: 'create great wall of china')
    user = create_user(first_name: 'Charles', last_name: 'Barkley',email: 'test2@success.com', password: '1234', password_confirmation: '1234')
    Membership.create!(user_id: user.id, project_id: project.id, role:"owner")

    sign_in(user)
    expect(current_path).to eq projects_path

    click_link '0'

    click_link 'New Task'

    click_button 'Create Task'
    expect(page).to have_content 'Description can\'t be blank'

    fill_in :task_description, with: 'Hard Task'
    fill_in :task_due_date, with: '2034-03-15'
    click_button 'Create Task'

    expect(page).to have_content 'Task was successfully created.'
    expect(page).to have_content 'Hard Task'
    expect(page).to have_content '03/15/2034'

    click_link 'Hard Task'
    expect(page).to have_content 'Due date: 03/15/2034'

    click_link "Edit"

    fill_in :task_description, with: 'Hard Task Edited'
    click_button 'Update Task'

    expect(page).to have_content 'Task was successfully updated.'
    expect(page).to have_content 'Hard Task Edited'

    page.find(".glyphicon-remove").click
    expect(page).to have_content "Task was successfully deleted."

  end
end
