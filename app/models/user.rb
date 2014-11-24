class User < ActiveRecord::Base
  devise :database_authenticatable, :recoverable, :validatable

  has_many :subscriptions
  has_many :seasons, through: :subscriptions

  validates :given_name, presence: true
  validates :surname, presence: true
end
