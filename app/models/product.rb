class Product < ApplicationRecord
  belongs_to :buyer, foreign_key: :buyer_id, class_name: 'User'
  belongs_to :event

  validates :name, presence: true

end
