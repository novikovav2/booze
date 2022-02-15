class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable, :validatable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable

  has_many :events
  has_many :products
  has_and_belongs_to_many :member_of, class_name: 'Event'
  has_and_belongs_to_many :eat, class_name: 'Product'

  validates :email, presence: true
  validates :password, presence: true
  validates :email, uniqueness: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, length: { in: 6..20 }
end
