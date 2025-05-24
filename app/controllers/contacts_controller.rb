class ContactsController < ApplicationController
  skip_authorization_check
  def new
  end

  def create
    name = params[:name]
    email = params[:email]
    message = params[:message]
    ContactMailer.contact_email(name, email, message).deliver_now
    flash[:notice] = "Thank you for contacting us! We'll get back to you soon."
    redirect_to contact_path
  end
end 