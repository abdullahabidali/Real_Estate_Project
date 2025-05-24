module Admin
  class CommentsController < ActiveAdmin::ResourceController
    skip_authorization_check
  end
end 