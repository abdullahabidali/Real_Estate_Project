class ReviewsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource :property
  load_and_authorize_resource :review, through: :property

  def create
    @property = Property.find(params[:property_id])
    @review = @property.reviews.build(review_params)
    @review.user = current_user
    if @review.save
      redirect_to @property, notice: "Review added!"
    else
      redirect_to @property, alert: "Review can't be blank."
    end
  end

  private

  def review_params
    params.require(:review).permit(:body)
  end
end 