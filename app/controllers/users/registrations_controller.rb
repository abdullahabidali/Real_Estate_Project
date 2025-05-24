# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  include Devise::Controllers::Helpers
  # skip_before_action :verify_authenticity_token, only: [:create]
  before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: [:update]
  layout 'authentication'

  # GET /resource/sign_up
  def new
    if user_signed_in?
      flash[:alert] = "You are already signed in. Please sign out to create a new account."
      redirect_to root_path
    else
      super
    end
  end

  # POST /resource
  def create
    build_resource(sign_up_params)

    Rails.logger.info "Submitted role: #{sign_up_params[:role]}"

    resource.save
    yield resource if block_given?
    if resource.persisted?
      # Assign role immediately after sign-up
      if resource.role == 'seller'
        resource.add_role(:seller)
      else
        resource.add_role(:buyer)
      end
      
      # Force sign out - we want the user to confirm their email first
      sign_out(current_user) if user_signed_in?
      
      if resource.active_for_authentication?
        set_flash_message! :notice, "A confirmation email has been sent. Please confirm your email, then sign in. <a href='#{dashboard_path}'>Go to your dashboard</a> after signing in to start listing properties.".html_safe
        respond_with resource, location: new_user_session_path
      else
        set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
        expire_data_after_sign_in!
        respond_with resource, location: new_user_session_path
      end
    else
      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource
    end
  end

  # GET /resource/edit
  def edit
    super
  end

  # PUT /resource
  def update
    super
  end

  # DELETE /resource
  def destroy
    super
  end

  # GET /resource/cancel
  def cancel
    super
  end

  protected

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :phone, :role])
  end

  # If you have extra params to permit, append them to the sanitizer.
  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :phone])
  end

  # The path used after sign up.
  def after_sign_up_path_for(resource)
    if resource.confirmed?
      if resource.role == 'seller'
        resource.add_role(:seller)
        flash[:notice] = "Welcome! You've been registered as a Property Seller. You can now start listing your properties."
      else
        resource.add_role(:buyer)
        flash[:notice] = "Welcome! You've been registered as a Property Buyer. You can now start browsing and saving properties."
      end
      dashboard_path
    else
      new_user_session_path
    end
  end

  # The path used after sign up for inactive accounts.
  def after_inactive_sign_up_path_for(resource)
    new_user_session_path
  end

  def update_resource(resource, params)
    if params[:role].present? && params[:role] != resource.role
      # Remove existing role
      resource.roles.destroy_all
      
      # Add new role
      if params[:role] == 'seller'
        resource.add_role(:seller)
        flash[:notice] = "Your account has been updated to a Property Seller account. You can now list properties for sale."
      else
        resource.add_role(:buyer)
        flash[:notice] = "Your account has been updated to a Property Buyer account."
      end
    end
    
    # Continue with normal update
    super
  end

  def after_update_path_for(resource)
    dashboard_path
  end
end
