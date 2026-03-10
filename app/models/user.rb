class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :validatable

  belongs_to :department
  has_many :bookings, dependent: :restrict_with_error

  before_validation :set_default_role, on: :create

  private

  def set_default_role
    self.role ||= "student"
  end
end
