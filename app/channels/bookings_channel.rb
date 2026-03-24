class BookingsChannel < ApplicationCable::Channel
  def subscribed
    stream_from "bookings_#{current_user.id}"
    stream_from "admin_bookings_dept_#{current_user.department_id}" if current_user.role == "admin"
  end

  def unsubscribed
    stop_all_streams
  end
end
