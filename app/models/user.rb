class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :validatable

  belongs_to :department
  has_many :bookings, dependent: :restrict_with_error
  before_validation :normalize_name
  validates :name, presence: true
  before_validation :set_default_role, on: :create

  private

  def set_default_role
    self.role ||= "student"
  end

  def normalize_name
    self.name = name.to_s.strip.presence
  end
end
