class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :resource
  belongs_to :department

  # validation: conflict detection
  BLOCKING_STATUSES = %w[pending approved].freeze

  validates :start_time, :end_time, presence: true # check data PRESENCE
  validate :end_time_after_start_time
  validate :minimum_duration_one_hour
  validate :no_overlapping_bookings_for_resource

  private

  def end_time_after_start_time
    return if start_time.blank? || end_time.blank? # check BLANK data
    return if end_time > start_time

    errors.add(:end_time, "must be after start time")
  end

  def minimum_duration_one_hour
    return if start_time.blank? || end_time.blank?
    return unless end_time > start_time
    return if (end_time - start_time) >= 1.hour

    errors.add(:base, "Booking must last at least one hour")
  end

end
