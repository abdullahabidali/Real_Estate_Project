class HomeController < ApplicationController
  skip_authorization_check

  def index
    @featured_properties = Property.order(created_at: :desc).limit(3)
  end
end 