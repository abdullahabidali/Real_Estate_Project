class MessagesController < ApplicationController
  before_action :set_property, only: [:new, :create]

  def new
    @message = Message.new
  end

  def create
    @message = Message.new(message_params)
    @message.property = @property
    @message.user = current_user

    if @message.save
      redirect_to @property, notice: 'Message was successfully sent.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_property
    @property = Property.find(params[:property_id])
  end

  def message_params
    params.require(:message).permit(:content)
  end
end
