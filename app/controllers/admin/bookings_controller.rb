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
    end
      redirect_to admin_bookings_path
  end

  private

  def require_admin!
    redirect_to root_path, alert: "Not authorized" unless current_user&.role == "admin"
  end
end
