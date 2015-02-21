class Rollover < ActiveRecord::Base
  belongs_to :season
  belongs_to :subscription
  devise :confirmable, reconfirmable: false

  validates :season, presence: true
  validates :subscription, presence: true
end
