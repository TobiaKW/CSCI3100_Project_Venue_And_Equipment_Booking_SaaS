class Department < ApplicationRecord
  has_many :users, dependent: :restrict_with_error
  has_many :resources, dependent: :restrict_with_error
  has_many :bookings, dependent: :restrict_with_error
end
