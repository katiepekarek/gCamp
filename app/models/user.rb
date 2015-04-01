class User < ActiveRecord::Base
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true

  has_many :memberships, dependent: :destroy
  has_many :projects, :through => :memberships
  has_many :comments

  has_secure_password

  def full_name
    "#{first_name} #{last_name}"
  end

  def project_member_verify(project)
    self.memberships.find_by(project_id: project.id) != nil
  end

  def project_owner_verify(project)
    self.memberships.find_by(project_id: project.id).role == "owner"
  end

  def project_member_of(user)
    user.projects.map(&:users).flatten.include?(self)
  end
end
