class AdminMailer < ApplicationMailer
  def pending_approval(booking)
    @booking = booking
    @department = booking.department
    mail(
      to: admin_emails_for_department(@department),
      subject: "Booking requested: #{@booking.resource.name} (#{@booking.start_time.strftime('%Y-%m-%d %H:%M')})"
    )
  end

  private

  def admin_emails_for_department(department)
    User.where(role: "admin", department_id: department.id).pluck(:email)
  end
end

