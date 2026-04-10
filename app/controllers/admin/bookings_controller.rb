class Admin::BookingsController < ApplicationController
  before_action :require_admin!

  def index
    # Pending bookings table - only for resources in admin's department
    @pending_bookings = Booking
                        .joins(:resource)
                        .where(status: "pending")
                        .where("resources.department_id = ?", current_user.department_id)
                        .includes(:user, :resource)
                        .order(created_at: :desc)

    # Approved bookings for this week - only for resources in admin's department
    week_start = Date.today.beginning_of_week
    week_end = week_start.end_of_week
    @week_bookings = Booking
                     .joins(:resource)
                     .where(status: "approved")
                     .where("resources.department_id = ?", current_user.department_id)
                     .where("DATE(start_time) BETWEEN ? AND ?", week_start, week_end)
                     .includes(:user, :resource)
                     .order(start_time: :asc)

    # Chart data with Redis caching (1 hour TTL)
    @bookings_by_status = cached_chart_data("bookings_by_status") do
      booking_status_data
    end

    @booking_trends = cached_chart_data("booking_trends") do
      booking_trends_data
    end

    @resource_utilization = cached_chart_data("resource_utilization") do
      resource_utilization_data
    end
  end

  def update
    booking = Booking.find(params[:id])
    # Ensure admin only updates their own department’s bookings
    if booking.resource.department == current_user.department
      Booking.transaction do
        booking.update!(status: params[:status])

        if params[:status] == "approved"
          # Keep your policy: many pending requests can exist, but only one can be approved.
          # reject all other pending bookings for the same resource same time
          Booking
            .where(resource_id: booking.resource_id, status: "pending")
            .where.not(id: booking.id)
            .where("start_time < ? AND end_time > ?", booking.end_time, booking.start_time)
            .update_all(status: "rejected", updated_at: Time.current)
        end
      end
      # email the booking owner
      # smtp fail exit
      begin
        UserMailer.booking_decision(booking).deliver_now
      rescue StandardError => e
        Rails.logger.error("Booking decision email failed: #{e.class}: #{e.message}")
      end

      begin # server broadcast
        ActionCable.server.broadcast("bookings_#{booking.user_id}", {
          type: "booking_status_changed",
          booking_id: booking.id,
          status: params[:status],
          updated_at: Time.current
        })
      rescue StandardError => e
        Rails.logger.error("ActionCable broadcast failed: #{e.class}: #{e.message}")
      end
    end
    redirect_to admin_bookings_path
  end

  private

  def require_admin!
    redirect_to root_path, alert: "Not authorized" unless current_user&.role == "admin"
  end

  def cached_chart_data(chart_name)
    cache_key = "admin:chart:#{chart_name}:#{current_user.department_id}"
    cached = Rails.cache.read(cache_key)
    return cached if cached.present?

    data = yield
    Rails.cache.write(cache_key, data, expires_in: 1.hour)
    data
  end

  def booking_status_data
    statuses = Booking
               .joins(:resource)
               .where("resources.department_id = ?", current_user.department_id)
               .group(:status)
               .count

    statuses.transform_keys { |k| k.capitalize }
  end

  def booking_trends_data
    # Bookings per week from April to June for admin's department resources
    bookings = Booking
               .joins(:resource)
               .where("resources.department_id = ?", current_user.department_id)
               .where("start_time >= ? AND start_time <= ?", Date.new(2026, 4, 1), Date.new(2026, 6, 30))
               .group_by { |b| b.start_time.to_date.beginning_of_week }
               .transform_keys { |k| k.strftime("%b %d") }
               .transform_values(&:count)

    bookings.sort_by { |k, _| Date.strptime(k, "%b %d") }.to_h
  end

  def resource_utilization_data
    # Top 10 most booked resources in admin's department
    Booking
      .joins(:resource)
      .where("resources.department_id = ?", current_user.department_id)
      .group("resources.name")
      .count
      .sort_by { |_, v| -v }
      .first(10)
      .to_h
  end
end
