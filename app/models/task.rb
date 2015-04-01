class Task < ActiveRecord::Base
  validates :description, presence: true
  validate :not_past_date

  belongs_to :project
  has_many :comments, dependent: :destroy

  def not_past_date
    if self.due_date && self.due_date.past?
      self.errors.add(:due_date, "can't be in the past")
    end
  end
end
