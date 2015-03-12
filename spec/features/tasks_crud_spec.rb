require 'rails_helper'

feature 'Existing users CRUD tasks within projects' do
  scenario 'index lists all available cheeses with description, due_date' do
    project = Project.new(name: 'create great wall of china')
    project.save!

    sign_in_user
    expect(current_path).to eq root_path

    click_link 'Projects'
    click_link '0'

    click_link 'New Task'

    click_button 'Create Task'
    expect(page).to have_content 'Description can\'t be blank'

    fill_in :task_description, with: 'Hard Task'
    fill_in :task_due_date, with: '2015-03-15'
    click_button 'Create Task'

    expect(page).to have_content 'Task was successfully created.'
    expect(page).to have_content 'Hard Task'
    expect(page).to have_content '03/15/2015'

    click_link 'Hard Task'
    expect(page).to have_content 'Due date: 03/15/2015'

    click_link "Edit"

    fill_in :task_description, with: 'Hard Task Edited'
    click_button 'Update Task'

    expect(page).to have_content 'Task was successfully updated.'
    expect(page).to have_content 'Hard Task Edited'

    click_link 'Delete'
    expect(page).to have_content "Task was successfully deleted."

  end
end
