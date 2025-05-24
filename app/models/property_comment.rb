class PropertyComment < ApplicationRecord
  belongs_to :property
  belongs_to :user

  validates :content, presence: true, length: { minimum: 2, maximum: 1000 }
  validates :property_id, presence: true
  validates :user_id, presence: true

  def self.ransackable_attributes(auth_object = nil)
    ["content", "created_at", "id", "property_id", "updated_at", "user_id"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["property", "user"]
  end
end
