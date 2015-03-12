class AddRoleColumn < ActiveRecord::Migration
  def change
    add_column :memberships, :role, :string
  end
end
