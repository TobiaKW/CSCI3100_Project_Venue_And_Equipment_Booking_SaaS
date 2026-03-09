class User < ApplicationRecord
  belongs_to :department
  has_many :bookings, dependent: :restrict_with_error

  validates :email, presence: true, uniqueness: true
end
