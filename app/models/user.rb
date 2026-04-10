class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :validatable

  belongs_to :department
  has_many :bookings, dependent: :restrict_with_error

  validates :name, :password, :role, presence: true
  validate :username_must_be_unique
  
  before_validation :normalize_name
  before_validation :set_default_role, on: :create

  private

  def set_default_role
    self.role ||= "student"
  end

  def normalize_name
    self.name = name.to_s.strip.presence
  end

  def username_must_be_unique
    return if name.blank?
    return unless self.class.where("LOWER(name) = ?", name.downcase).where.not(id: id).exists?

    errors.add(:base, "Username already exists")
  end
end
