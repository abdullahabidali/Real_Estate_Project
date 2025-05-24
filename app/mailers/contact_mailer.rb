class ContactMailer < ApplicationMailer
  default to: ENV['ADMIN_EMAIL'] || 'admin@example.com'

  def contact_email(name, email, message)
    @name = name
    @email = email
    @message = message
    mail(from: email, subject: "New Contact Form Message from #{@name}")
  end
end
