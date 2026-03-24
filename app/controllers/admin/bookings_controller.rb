class Admin::BookingsController < ApplicationController
  before_action :require_admin!

  def index
    @bookings = Booking
                .where(department: current_user.department, status: "pending")
                .includes(:user, :resource)
  end

  def update
    booking = Booking.find(params[:id])
    # Ensure admin only updates their own department’s bookings
    if booking.department_id == current_user.department_id
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
end
