module Admin
  class AdminUsersController < ActiveAdmin::ResourceController
    skip_authorization_check
  end
end 