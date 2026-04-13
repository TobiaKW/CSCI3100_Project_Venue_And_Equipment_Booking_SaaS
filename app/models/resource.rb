class Resource < ApplicationRecord
  belongs_to :department
  has_many :bookings, dependent: :restrict_with_error

  validates :name, presence: true

  def has_location?
    latitude.present? && longitude.present?
  end

  def self.by_similarity(resources, term)
    term = ActiveRecord::Base.connection.quote(term)
    department_name = "(SELECT name FROM departments WHERE id = department_id)"
    search_field = "CONCAT_WS(' ', name, rtype, #{department_name}, seat_type)"
    similarity = "similarity(#{search_field}, #{term})"
    scored_resources = resources
      .select("*, #{similarity} AS score")
      .where("#{similarity} > 0.01")
      .order(:score => :desc)
    scored_resources.load
  end
end
