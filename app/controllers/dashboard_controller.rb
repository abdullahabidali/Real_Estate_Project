class DashboardController < ApplicationController
  skip_authorization_check
 
  def index
    redirect_to users_dashboard_path
  end
end 