class PropertiesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]
  before_action :set_property, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource

  def index
    @properties = Property.all
  end

  def show
  end

  def new
    @property = Property.new
  end

  def create
    @property = current_user.properties.build(property_params)
    if @property.save
      redirect_to @property, notice: 'Property was successfully created.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @property.update(property_params)
      redirect_to @property, notice: 'Property was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @property.destroy
    redirect_to properties_path, notice: 'Property was successfully deleted.'
  end

  def search
    @properties = Property.all

    @properties = @properties.where(property_type: params[:property_type]) if params[:property_type].present?
    @properties = @properties.where("city ILIKE ?", "%#{params[:city]}%") if params[:city].present?
    @properties = @properties.where("price >= ?", params[:min_price]) if params[:min_price].present?
    @properties = @properties.where("price <= ?", params[:max_price]) if params[:max_price].present?
    @properties = @properties.where(bedrooms: params[:bedrooms]) if params[:bedrooms].present?
    @properties = @properties.where(bathrooms: params[:bathrooms]) if params[:bathrooms].present?
    @properties = @properties.where(status: params[:status]) if params[:status].present?

    render :index
  end

  private

  def set_property
    @property = Property.find(params[:id])
  end

  def property_params
    params.require(:property).permit(:title, :description, :price, :location, :property_type, :status, :bedrooms, :bathrooms, :area, :image)
  end
end
