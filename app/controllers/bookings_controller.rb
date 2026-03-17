class BookingsController < ApplicationController
  def index
    @bookings = Booking.all
  end

  def new
    @resource = Resource.find(params[:resource_id])
    @booking = Booking.new(resource: @resource)
  end

  def create
    @resource = Resource.find(params[:resource_id])
    @booking  = current_user.bookings.build(booking_params.merge(
      resource: @resource,
      department: current_user.department,
      status: "pending"
    ))
    if @booking.save
      redirect_to bookings_path, notice: "Booking requested."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def booking_params
    params.require(:booking).permit(:resource_id, :start_time, :end_time)
  end
end
