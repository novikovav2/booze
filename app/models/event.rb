class Event < ApplicationRecord
  # after_create :new_joinID

  # Fields: name, description, evented_at, user_id, join_id
  belongs_to :user
  has_many :products
  has_and_belongs_to_many :members, class_name: 'User'

  validates :name, presence: true
  validates :join_id, uniqueness: true

  # def new_joinID
  #   self.join_id = (0...8).map { (65 + rand(26)).chr }.join
  # end
end
