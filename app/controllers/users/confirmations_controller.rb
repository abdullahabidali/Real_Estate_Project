# frozen_string_literal: true

class Users::ConfirmationsController < Devise::ConfirmationsController
  # GET /resource/confirmation/new
  def new
    super
  end

  # POST /resource/confirmation
  def create
    super do |resource|
      if resource.errors.empty?
        flash[:notice] = "A new confirmation email has been sent to your email address. Please check your inbox and follow the instructions to confirm your account."
      end
    end
  end

  # GET /resource/confirmation?confirmation_token=abcdef
  def show
    super do |resource|
      if resource.errors.empty?
        # Assign the correct role if not already assigned
        if resource.roles.blank?
          if resource.role == 'seller'
            resource.add_role(:seller)
          else
            resource.add_role(:buyer)
          end
        end
        flash[:notice] = "Your email address has been successfully confirmed. You can now sign in to your account."
      end
    end
  end

  protected

  # The path used after resending confirmation instructions.
  def after_resending_confirmation_instructions_path_for(resource_name)
    new_user_session_path
  end

  # The path used after confirmation.
  def after_confirmation_path_for(resource_name, resource)
    new_user_session_path
  end
end
