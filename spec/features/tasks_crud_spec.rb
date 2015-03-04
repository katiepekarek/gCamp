require 'rails_helper'

feature 'Existing users CRUD tasks' do
  scenario 'index lists all available cheeses with description, due_date' do
    task = Task.new(description: 'Crud this', due_date: '2015-03-12')
    task.save!

    sign_in_user
    expect(current_path).to eq root_path

    click_link 'Tasks'
    expect(current_path).to eq tasks_path

    expect(page).to have_link 'Crud this'
    expect(page).to have_content '03/12/2015'

  end

  scenario 'can make a new task from the new task form' do
    sign_in_user
    expect(current_path).to eq root_path

    click_link 'Tasks'
    expect(current_path).to eq tasks_path

    click_link 'New Task'
    expect(current_path).to eq new_task_path

    click_button 'Create Task'
    expect(page).to have_content 'Description can\'t be blank'

    fill_in :task_description, with: 'Hard Task'
    fill_in :task_due_date, with: '2015-03-15'
    click_button 'Create Task'

    expect(current_path).to eq task_path(Task.last.id)
    expect(page).to have_content 'Task was successfully created.'
    expect(page).to have_content 'Hard Task'
    expect(page).to have_content 'Due date: 03/15/2015'

  end

  scenario 'can edit a task from the task index page' do
    task = Task.new(description: 'Crud this', due_date: '2015-03-12')
    task.save!

    sign_in_user
    expect(current_path).to eq root_path

    click_link 'Tasks'
    expect(current_path).to eq tasks_path

    expect(page).to have_link 'Crud this'
    expect(page).to have_content '03/12/2015'

    click_link 'Edit'
    expect(page).to have_content 'Editing Tasks'

    fill_in :task_description, with: 'Hard Task Edited'
    click_button 'Update Task'

    expect(current_path).to eq tasks_path
    expect(page).to have_content 'Task was successfully updated.'
    expect(page).to have_content 'Hard Task Edited'
  end

  scenario 'index links to show via the task description' do
    task = Task.new(description: 'Crud', due_date: '2015-03-12')
    task.save!
    sign_in_user

    click_link 'Tasks'
    expect(current_path).to eq tasks_path

    click_link 'Crud'

    expect(page).to have_content 'Crud'
    expect(page).to have_content 'Due date: 03/12/2015'
  end

  scenario 'show contains links to the index, edit, and destroy actions' do
    task = Task.new(description: 'Crud', due_date: '2015-03-12')
    task.save!

    sign_in_user
    expect(current_path).to eq root_path

    click_link 'Tasks'
    expect(current_path).to eq tasks_path

    expect(page).to have_link 'Crud'
    expect(page).to have_content '03/12/2015'

    expect(find_link('New Task')[:href]).to eq(new_task_path)
    expect(find_link('Edit')[:href]).to eq(edit_task_path(Task.last.id))
    expect(find_link('Delete')[:href]).to eq(task_path(Task.last.id))
  end

  scenario 'clicking the destroy link on index page destroys the task and redirects to tasks index' do
    task = Task.new(description: 'Crud', due_date: '2015-03-12')
    task.save!

    sign_in_user
    expect(current_path).to eq root_path

    click_link 'Tasks'
    expect(current_path).to eq tasks_path

    click_link 'Delete'
    expect(page).to have_content "Task was successfully deleted."

  end
end

feature 'Unauthenticated users cannot CRUD tasks' do
  scenario 'attempt to login by an unauthenticated user causes a flash message and redirect' do
    visit tasks_path

    expect(current_path).to eq signin_path
    expect(page).to have_content 'You must sign in'
  end
end
