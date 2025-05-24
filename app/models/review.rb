class Review < ApplicationRecord
  belongs_to :user
  belongs_to :property

  validates :body, presence: true
end
