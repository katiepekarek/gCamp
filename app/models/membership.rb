class Membership <ActiveRecord::Base
  validates :user_id, presence: true
  validates :user_id, uniqueness: { message: "has already been added to this project" }

  belongs_to :user
  belongs_to :project

  ROLE = ["member", "owner"]

end
