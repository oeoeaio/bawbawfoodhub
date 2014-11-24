class Season < ActiveRecord::Base
  has_many :subscriptions
  has_many :users, through: :subscriptions

  validates :slug, uniqueness: true, presence: true
end
