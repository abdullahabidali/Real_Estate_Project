class UsersController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource

  def show
    @user = current_user
    @properties = @user.properties.order(created_at: :desc)
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update(user_params)
      redirect_to profile_path, notice: 'Profile updated successfully.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def dashboard
    @user = current_user
    @properties = current_user.properties
    @favorite_properties = current_user.favorite_properties
    
    # Get messages for the current user's properties (messages received)
    property_ids = @properties.pluck(:id)
    @recent_messages = Message.where(property_id: property_ids)
                             .where.not(user_id: current_user.id)
                             .order(created_at: :desc)
                             .limit(5)
  end

  def profile
    @user = current_user
  end

  def roles_debug
    render plain: "Current user: #{current_user.email}\nRoles: #{current_user.roles.pluck(:name).join(', ')}\nSeller?: #{current_user.seller?}"
  end

  def change_role
    new_role = params[:role]
    if current_user.change_role(new_role)
      redirect_to dashboard_path, notice: "Your account has been updated to a #{new_role.capitalize} account."
    else
      redirect_to dashboard_path, alert: "Failed to update role."
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :phone, :avatar)
  end
end
