class Campaign < ApplicationRecord
  before_validation :set_status, on: :create
  after_validation :set_member, on: :create

  enum status: [:pending, :finished]
  
  belongs_to :user
  has_many :members, dependent: :destroy
  validates :title, :description, :user, :status, presence: true

  def set_status
    self.status = :pending
  end

  def set_member
    self.members << Member.create(name: self.user.name, email: self.user.email)
  end
end
