class MessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_property, only: [:new, :create, :index]
  before_action :set_message, only: [:show]
  authorize_resource

  def index
    @messages = Message.for_property(@property)
                      .where(user: [current_user, @property.user])
                      .order(created_at: :asc)
  end

  def new
    @message = Message.new
  end

  def create
    @message = Message.new(message_params)
    @message.property = @property
    @message.user = current_user

    if @message.save
      # Notify the property owner about the new message
      if @property.user != current_user
        # You can add notification logic here (e.g., email, push notification)
      end
      
      redirect_to property_messages_path(@property), notice: 'Message was successfully sent.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_property
    @property = Property.find(params[:property_id])
  end

  def set_message
    @message = Message.find(params[:id])
  end

  def message_params
    params.require(:message).permit(:content)
  end
end
