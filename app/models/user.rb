class User < ActiveRecord::Base
  devise :database_authenticatable, :recoverable, :validatable

  has_secure_password
  has_many :subscriptions
  has_many :seasons, through: :subscriptions
end
