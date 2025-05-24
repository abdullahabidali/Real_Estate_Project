class HomeController < ApplicationController
  skip_before_action :authenticate_user!
  skip_authorization_check

  def index
    @featured_properties = Property.where(featured: true).limit(6)
    @latest_properties = Property.order(created_at: :desc).limit(6)
  end
end 