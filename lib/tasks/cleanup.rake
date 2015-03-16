namespace :cleanup do
  desc "Removes all memberships where their users have already been deleted"
  task list: :environment do
    orphaned_user_memberships = Membership.where.not(user_id: User.pluck(:id)).delete_all
    puts "#{orphaned_user_memberships} memberships where their users have already been deleted were removed"
  end

  desc "Removes all memberships where their projects have already been deleted"
  task list: :environment do
    orphaned_project_memberships = Membership.where.not(project_id: Project.pluck(:id)).delete_all
    puts "#{orphaned_project_memberships} memberships where their projects have already been deleted were deleted"
  end

  desc "Removes any memberships with a null project_id or user_id"
  task list: :environment do
    remove_null_ids = Membership.where(project_id = nil && user_id = nil).delete_all
    puts "#{remove_null_ids} memberships were removed that had either a null project_id or user_id"
  end

  desc "Removes all tasks where their projects have been deleted"
  task list: :environment do
   orphaned_tasks = Task.where.not(project_id: Project.pluck(:id)).delete_all
   puts "#{orphaned_tasks} tasks were deleted where their projects had been deleted"
  end

  desc "Removes any tasks with null project_id"
  task list: :environment do
    remove_null_project_id = Task.where(project_id: nil).delete_all
    puts "#{remove_null_project_id} tasks were deleted with a null project_id"
  end

  desc "Removes all comments where their tasks have been deleted"
  task list: :environment do
    remove_orphaned_comments = Comment.where.not(task_id: Task.pluck(:id)).delete_all
    puts "#{remove_orphaned_comments} comments were deleted where their tasks were already delted"
  end

  desc "Sets the user_id of comments to nil if their users have been deleted"
  task list: :environment do
    update_comment_user_id = Comment.where.not(user_id: User.pluck(:id)).update_all(user_id: nil)
    puts "#{update_comment_user_id} user_ids were updated to nil if the user was already deleted"
  end
end
