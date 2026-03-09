class Resource < ApplicationRecord
  belongs_to :department
  has_many :bookings, dependent: :restrict_with_error
end
