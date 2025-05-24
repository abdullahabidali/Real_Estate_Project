class FavoritesController < ApplicationController
  before_action :authenticate_user!
  authorize_resource

  def create
    @property = Property.find(params[:property_id])
    current_user.favorites.create(property: @property)
    redirect_to @property, notice: 'Property added to favorites.'
  end

  def destroy
    @property = Property.find(params[:property_id])
    current_user.favorites.find_by(property: @property).destroy
    redirect_to @property, notice: 'Property removed from favorites.'
  end
end
