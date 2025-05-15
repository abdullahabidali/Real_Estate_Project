class Property < ApplicationRecord
  validates :title, presence: true, length: { minimum: 5, maximum: 100 }
  validates :description, presence: true, length: { minimum: 20 }
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :address, presence: true
  validates :city, presence: true
  validates :state, presence: true
  validates :zip_code, presence: true, format: { with: /\A\d{5}(-\d{4})?\z/, message: "should be in the format 12345 or 12345-6789" }
  validates :bedrooms, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :bathrooms, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :area, presence: true, numericality: { greater_than: 0 }
  validates :property_type, presence: true, inclusion: { in: %w[house apartment condo townhouse land commercial] }
  validates :status, presence: true, inclusion: { in: %w[available sold pending] }

  # Add a scope for available properties
  scope :available, -> { where(status: 'available') }
  
  # Add a scope for properties by type
  scope :by_type, ->(type) { where(property_type: type) }
  
  # Add a scope for properties by price range
  scope :price_range, ->(min, max) { where(price: min..max) }

  # Add these scopes to your existing Property model
  scope :by_bathrooms, ->(count) { where("bathrooms >= ?", count) }
  scope :by_status, ->(status) { where(status: status) }
  scope :search_by_city, ->(city) { where("city ILIKE ?", "%#{city}%") }

  belongs_to :user
  has_many_attached :images
  has_many :favorites, dependent: :destroy
  has_many :favorited_by_users, through: :favorites, source: :user
  has_many :messages, dependent: :destroy
  has_one_attached :image

  def self.search(query)
    if query.present?
      where('title ILIKE ? OR description ILIKE ? OR location ILIKE ?', "%#{query}%", "%#{query}%", "%#{query}%")
    else
      all
    end
  end
end
