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
      booking.update!(status: params[:status])
      # email the booking owner
      # smtp fail exit
      begin
        UserMailer.booking_decision(booking).deliver_now
      rescue StandardError => e
        Rails.logger.error("Booking decision email failed: #{e.class}: #{e.message}")
      end
    end
      redirect_to admin_bookings_path
  end

  private

  def require_admin!
    redirect_to root_path, alert: "Not authorized" unless current_user&.role == "admin"
  end
end
