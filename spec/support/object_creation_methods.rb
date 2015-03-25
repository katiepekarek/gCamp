def create_project(options={})
  defaults = {name: "Sail the seven seas"}
  Project.create(defaults.merge(options))
end

def create_user(options={})
  defaults = {first_name: 'Charles', last_name: 'Barkley',email: 'test2@success.com', password: '1234', password_confirmation: '1234'}

  User.create!(defaults.merge(options))
end
