class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :resource
  belongs_to :department # should not exist since this should be inferred directly from user / resource?

  BLOCKING_STATUSES = %w[approved].freeze
  validates :start_time, :end_time, presence: true
  validate :end_time_after_start_time
  validate :minimum_duration_one_hour
  validate :no_overlapping_bookings_for_resource
  validate :seven_days_in_advance, on: :create
  validate :no_overnight_bookings_of_venue

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

  def no_overlapping_bookings_for_resource
    return if resource_id.blank? || start_time.blank? || end_time.blank?
    return unless end_time > start_time

    scope = Booking
            .where(resource_id: resource_id)
            # .where(status: BLOCKING_STATUSES)
            # in reality should not allow placing booking even in pending status?
    scope = scope.where.not(id: id) if persisted? # for update operation later

    # Half-open intervals [start_time, end_time): overlap iff
    # existing.start < self.end AND existing.end > self.start
    overlaps = scope.where("start_time < ? AND end_time > ?", end_time, start_time)
    return unless overlaps.exists?

    errors.add(:base, "This time overlaps another booking for this resource")
  end

  def seven_days_in_advance
    return if start_time.blank? || end_time.blank?
    return if start_time >= 7.days.from_now

    errors.add(:base, "Booking must be made at least 7 days in advance")
  end

  def no_overnight_bookings_of_venue
    return if !resource.is_a?(Resource) || resource.rtype == "equipment"
    return if start_time.blank? || end_time.blank?
    return unless end_time > start_time
    return if end_time.to_date == start_time.to_date
    # day alone fails across months, e.g. Apr 1 vs May 1
    errors.add(:base, "You cannot book a venue for overnight")
  end
end
