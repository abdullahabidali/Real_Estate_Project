class Rate < ApplicationRecord
  belongs_to :rater, class_name: 'User'
  belongs_to :rateable, polymorphic: true

  validates :stars, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 5 }
  validates :dimension, presence: true
  validates :rater_id, uniqueness: { scope: [:rateable_id, :rateable_type, :dimension] }
end
