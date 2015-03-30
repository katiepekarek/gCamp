def create_project(options={})
  defaults = {name: "Sail the seven seas"}
  Project.create(defaults.merge(options))
end

def create_user(options={})
  defaults = {first_name: 'Charles', last_name: 'Barkley',email: 'test2@success.com', password: '1234', password_confirmation: '1234', admin: true}

  User.create!(defaults.merge(options))
end

def create_user_non_admin(options={})
  defaults = {first_name: 'Charles', last_name: 'Barkley',email: 'test2@success.com', password: '1234', password_confirmation: '1234', admin: false}

  User.create!(defaults.merge(options))
end

def create_membership(options={})
  defaults = {user_id: create_user, project_id: create_project, role: 'member'}

  Membership.create!(defaults.merge(options))
end
