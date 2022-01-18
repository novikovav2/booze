class Event < ApplicationRecord
  # Fields: name, description, evented_at, user_id
  belongs_to :user
  has_many :products

  validates :name, presence: true

end
