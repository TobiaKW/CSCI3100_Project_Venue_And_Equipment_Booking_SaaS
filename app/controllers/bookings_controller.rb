class BookingsController < ApplicationController
  def index
    @bookings = Booking.all
  end

  def new
    @booking = Booking.new
  end

  def create
    @booking = Booking.new(booking_params)
    
  end

  private

  def booking_params
    params.require(:booking).permit(:resource_id, :start_time, :end_time)
  end
end
