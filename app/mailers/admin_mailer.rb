class AdminMailer < ApplicationMailer
  # Same-department admins first; if none, any admin (so mail still sends when only one dept has an admin in seeds).
  def self.pending_approval_recipients(booking)
    department = booking.resource.department
    emails = User.where(role: "admin", department_id: department.id).pluck(:email)
    return emails if emails.any?

    User.where(role: "admin").pluck(:email).uniq
  end

  def pending_approval(booking)
    @booking = booking
    @department = booking.resource.department
    emails = self.class.pending_approval_recipients(booking)
    if emails.blank?
      raise ArgumentError, "AdminMailer#pending_approval: no admin recipients for booking #{booking.id}"
    end

    mail(
      to: emails,
      subject: "Booking requested: #{@booking.resource.name} (#{@booking.start_time.strftime('%Y-%m-%d %H:%M')})"
    )
  end
end
