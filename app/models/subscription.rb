class Subscription < ActiveRecord::Base
  belongs_to :season
  belongs_to :user
  validates :season, presence: true
  validates :user, presence: true

  accepts_nested_attributes_for :user
end
