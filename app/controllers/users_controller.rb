class UsersController < ApplicationController
  before_action :authenticate_user!

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
    @my_properties = current_user.properties.order(created_at: :desc)
    @favorite_properties = current_user.favorite_properties.order(created_at: :desc)
  end

  private

  def user_params
    params.require(:user).permit(:name, :phone, :avatar)
  end
end
