class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :resource
  belongs_to :department
end
