class User < ActiveRecord::Base
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true, uniqueness: true

  has_many :memberships, dependent: :destroy
  has_many :projects, :through => :memberships
  has_many :comments

  has_secure_password

  def full_name
    "#{first_name} #{last_name}"
  end

end
