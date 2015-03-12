class Membership <ActiveRecord::Base
  validates :user, presence: true
  validates :user, uniqueness: {scope: :project_id, message: "has already been added to this project" }

  belongs_to :user
  belongs_to :project

  ROLE = ["member", "owner"]

end
