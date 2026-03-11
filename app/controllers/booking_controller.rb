class BookingsController < ApplicationController
    def index # Loads all bookings that belong to the currently logged-in user
      @bookings = current_user.bookings.includes(:resource)
    end

    def new  # Prepares a blank Booking and finds the Resource the user is trying to book
      @resource = Resource.find(params[:resource_id])
      @booking  = Booking.new
    end

    def create # create a new booking record, default pending status
      @resource = Resource.find(params[:resource_id])
      @booking  = current_user.bookings.build(booking_params.merge(
        resource: @resource,
        department: current_user.department,
        status: "pending"
      ))

      if @booking.save # if save is successful, redirect to the bookings index page with a message
        redirect_to bookings_path, notice: "Booking requested."
      else
        render :new, status: :unprocessable_entity
      end
    end

    private

    def booking_params # we need start/end time to detect conflicts
      params.require(:booking).permit(:start_time, :end_time)
    end
end
