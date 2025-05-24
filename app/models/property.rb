class Property < ApplicationRecord
  include ActionView::Helpers::NumberHelper
  
  belongs_to :user
  has_many_attached :images
  has_many :favorites, dependent: :destroy
  has_many :favorited_by_users, through: :favorites, source: :user
  has_many :messages, dependent: :destroy
  has_many :property_comments, dependent: :destroy
  has_many :reviews, dependent: :destroy

  geocoded_by :full_address
  after_validation :geocode, if: ->(obj){ obj.address_changed? || obj.city_changed? || obj.state_changed? || obj.zip_code_changed? }

  validates :title, presence: true, length: { minimum: 5, maximum: 100 }
  validates :description, presence: true, length: { minimum: 20 }
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0, message: "must be greater than or equal to 0 PKR" }
  validates :address, presence: true
  validates :city, presence: true
  validates :state, presence: true
  validates :zip_code, presence: true, format: { with: /\A\d{5}(-\d{4})?\z/, message: "should be in the format 12345 or 12345-6789" }
  validates :bedrooms, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :bathrooms, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :area, presence: true, numericality: { greater_than: 0 }
  validates :property_type, presence: true
  validates :status, presence: true
  validates :images, presence: true

  # Add scopes for property status
  scope :available, -> { where(status: 'available') }
  scope :sold, -> { where(status: 'sold') }
  scope :pending, -> { where(status: 'pending') }
  
  # Add a scope for properties by type
  scope :by_type, ->(type) { where(property_type: type) }
  
  # Add a scope for properties by price range
  scope :price_range, ->(min, max) { where(price: min..max) }

  # Add these scopes to your existing Property model
  scope :by_bathrooms, ->(count) { where("bathrooms >= ?", count) }
  scope :by_status, ->(status) { where(status: status) }
  scope :search_by_city, ->(city) { where("city ILIKE ?", "%#{city}%") }

  ratyrate_rateable "overall"

  def self.search(query)
    if query.present?
      where('title ILIKE ? OR description ILIKE ? OR city ILIKE ? OR state ILIKE ?', 
            "%#{query}%", "%#{query}%", "%#{query}%", "%#{query}%")
    else
      all
    end
  end

  def self.ransackable_attributes(auth_object = nil)
    ["area", "bathrooms", "bedrooms", "created_at", "description", "id", 
     "price", "property_type", "status", "title", "updated_at", 
     "user_id", "address", "city", "state", "zip_code", "latitude", "longitude"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["user", "favorites", "favorited_by", "messages", "property_comments", "images_attachments", "images_blob"]
  end

  def formatted_price
    number_to_currency(price, unit: "Rs. ", precision: 0, delimiter: ",")
  end

  def full_address
    [address, city, state, zip_code].compact.join(', ')
  end

  def average_rating
    self.rate_average_without_dimension
  end
end
