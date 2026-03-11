class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :resource
  belongs_to :department

  # TODO: Conflict detection and approval workflow
end
