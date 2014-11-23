class User < ActiveRecord::Base
  has_secure_password
  has_many :subscriptions
  has_many :seasons, through: :subscriptions
end
