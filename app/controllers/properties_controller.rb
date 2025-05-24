class PropertiesController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_property, only: [:show, :edit, :update, :destroy]
  authorize_resource
  
  # Add a direct check for seller role
  before_action :check_seller, only: [:new, :create, :edit, :update, :destroy]

  def index
    @properties = Property.all
    authorize! :read, Property

    @properties = @properties.where(property_type: params[:property_type]) if params[:property_type].present?
    @properties = @properties.where("city ILIKE ?", "%#{params[:city]}%") if params[:city].present?
    @properties = @properties.where("price >= ?", params[:min_price]) if params[:min_price].present?
    @properties = @properties.where("price <= ?", params[:max_price]) if params[:max_price].present?
    @properties = @properties.where(bedrooms: params[:bedrooms]) if params[:bedrooms].present?
    @properties = @properties.where(bathrooms: params[:bathrooms]) if params[:bathrooms].present?
    @properties = @properties.where(status: params[:status]) if params[:status].present?

    # Sorting
    case params[:sort]
    when 'title_asc'
      @properties = @properties.order(title: :asc)
    when 'title_desc'
      @properties = @properties.order(title: :desc)
    when 'price_asc'
      @properties = @properties.order(price: :asc)
    when 'price_desc'
      @properties = @properties.order(price: :desc)
    end

    # Pagination
    @properties = @properties.page(params[:page]).per(6)
  end

  def show
    @nearby_properties = Property.near([@property.latitude, @property.longitude], 5, units: :km)
                                .where.not(id: @property.id)
                                .limit(3)
    @review = Review.new
  end

  def new
    # Enhanced debug logging
    Rails.logger.info "=== NEW PROPERTY DEBUG ==="
    Rails.logger.info "Current User ID: #{current_user.id}"
    Rails.logger.info "Current User Email: #{current_user.email}"
    Rails.logger.info "User Roles: #{current_user.roles.pluck(:name)}"
    Rails.logger.info "Is Seller?: #{current_user.seller?}"
    Rails.logger.info "User Role Attribute: #{current_user.role}"
    Rails.logger.info "Can Create Property?: #{current_ability.can?(:create, Property)}"
    Rails.logger.info "========================"
    
    @property = Property.new
  end

  def create
    # Enhanced debug logging
    Rails.logger.info "=== CREATE PROPERTY DEBUG ==="
    Rails.logger.info "Current User ID: #{current_user.id}"
    Rails.logger.info "Current User Email: #{current_user.email}"
    Rails.logger.info "User Roles: #{current_user.roles.pluck(:name)}"
    Rails.logger.info "Is Seller?: #{current_user.seller?}"
    Rails.logger.info "User Role Attribute: #{current_user.role}"
    Rails.logger.info "Can Create Property?: #{current_ability.can?(:create, Property)}"
    Rails.logger.info "Property Params: #{property_params.inspect}"
    Rails.logger.info "=========================="
    
    @property = current_user.properties.build(property_params)
    if @property.save
      redirect_to @property, notice: 'Property was successfully created.'
    else
      Rails.logger.info "Property Save Errors: #{@property.errors.full_messages}"
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

  private

  def set_property
    @property = Property.find(params[:id])
  end

  def property_params
    params.require(:property).permit(:title, :description, :price, :address, :city, :state, :zip_code, :property_type, :status, :bedrooms, :bathrooms, :area, images: [])
  end
  
  def check_seller
    unless current_user.seller?
      Rails.logger.info "=== SELLER CHECK FAILED ==="
      Rails.logger.info "Current User ID: #{current_user.id}"
      Rails.logger.info "Current User Email: #{current_user.email}"
      Rails.logger.info "User Roles: #{current_user.roles.pluck(:name)}"
      Rails.logger.info "Is Seller?: #{current_user.seller?}"
      Rails.logger.info "User Role Attribute: #{current_user.role}"
      Rails.logger.info "========================="
      
      flash[:alert] = "Only sellers can manage properties."
      redirect_to properties_path
    end
  end
end
