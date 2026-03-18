class UserMailer < ApplicationMailer
  def booking_decision(booking)
    @booking = booking
    @resource = booking.resource
    @department = booking.department

    mail(
      to: @booking.user.email,
      subject: "Your booking was #{@booking.status}!"
    )
  end
end

