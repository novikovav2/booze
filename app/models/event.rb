class Event < ApplicationRecord
  # Fields: name, description, evented_at, user_id, join_id
  belongs_to :user
  has_many :products, :dependent => :delete_all
  has_and_belongs_to_many :members, class_name: 'User'

  validates :name, presence: true
  validates :join_id, uniqueness: true

end
