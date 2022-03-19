class Product < ApplicationRecord
  belongs_to :buyer, foreign_key: :buyer_id, class_name: 'User'
  belongs_to :event
  # has_and_belongs_to_many :eaters, class_name: 'User'

  validates :name, presence: true
end
