class Resource < ApplicationRecord
  belongs_to :department
  has_many :bookings, dependent: :restrict_with_error

  validates :name, presence: true

  def has_location?
    latitude.present? && longitude.present?
  end
end
