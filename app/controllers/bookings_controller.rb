class BookingsController < ApplicationController
  def index
    @bookings = current_user.bookings.includes(:resource)
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
      # Notify admins (same department, else any admin). See Render logs for [mail] lines.
      recipients = AdminMailer.pending_approval_recipients(@booking)
      if recipients.any?
        begin
          AdminMailer.pending_approval(@booking).deliver_now
          Rails.logger.info(
            "[mail] pending_approval delivered to=#{recipients.join(',')} booking_id=#{@booking.id}"
          )
        rescue StandardError => e
          Rails.logger.error(
            "[mail] pending_approval FAILED booking_id=#{@booking.id}: #{e.class}: #{e.message}"
          )
        end
        begin
          ActionCable.server.broadcast("admin_bookings_dept_#{@booking.department_id}", {
            type: "new_booking_created",
            booking_id: @booking.id,
            html: render_to_string(partial: "admin/bookings/booking_row", locals: { booking: @booking })
          })
        rescue StandardError => e
          Rails.logger.error("ActionCable broadcast failed: #{e.class}: #{e.message}")
        end
      else
        Rails.logger.warn(
          "[mail] pending_approval SKIPPED: no User with role=admin booking_id=#{@booking.id}"
        )
      end
      redirect_to bookings_path, notice: "Booking requested."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def booking_params
    params_permitted = params.require(:booking).permit(:resource_id, :start_date, :start_time_only, :end_date, :end_time_only)
    
    # Merge separate date and time fields into datetime format
    if params_permitted[:start_date].present? && params_permitted[:start_time_only].present?
      params_permitted[:start_time] = "#{params_permitted[:start_date]} #{params_permitted[:start_time_only]}:00"
    end
    
    if params_permitted[:end_date].present? && params_permitted[:end_time_only].present?
      params_permitted[:end_time] = "#{params_permitted[:end_date]} #{params_permitted[:end_time_only]}:00"
    end
    
    # Remove the separate fields since we've merged them
    params_permitted.except(:start_date, :start_time_only, :end_date, :end_time_only)
  end
end
