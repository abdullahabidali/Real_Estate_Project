class UserMailer < ApplicationMailer
  include Devise::Controllers::UrlHelpers

  def confirmation_instructions(record, token, opts={})
    @token = token
    @resource = record
    
    mail(
      to: record.email,
      subject: 'Confirmation instructions'
    )
  end

  def reset_password_instructions(record, token, opts={})
    @token = token
    @resource = record
    
    mail(
      to: record.email,
      subject: 'Reset password instructions'
    )
  end

  def unlock_instructions(record, token, opts={})
    @token = token
    @resource = record
    
    mail(
      to: record.email,
      subject: 'Unlock instructions'
    )
  end
end 