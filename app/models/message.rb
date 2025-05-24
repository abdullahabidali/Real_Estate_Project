class Message < ApplicationRecord
  belongs_to :user
  belongs_to :property

  validates :content, presence: true, length: { minimum: 10, maximum: 1000 }
  
  # Add a scope to get messages for a specific property
  scope :for_property, ->(property) { where(property: property) }
  
  # Add a scope to get messages between two users
  scope :between_users, ->(user1, user2) { 
    where(user: user1, property: Property.where(user: user2))
    .or(where(user: user2, property: Property.where(user: user1)))
  }

  def self.ransackable_attributes(auth_object = nil)
    ["content", "created_at", "id", "property_id", "receiver_id", "sender_id", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["property", "sender", "receiver"]
  end
end
