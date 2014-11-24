class Subscription < ActiveRecord::Base
  SIZES = {
    "large" => 'Large Box',
    "standard" => 'Standard Box',
    "small" => 'Small Bag'
  }

  belongs_to :season
  belongs_to :user
  validates :season, presence: true
  validates :user, presence: true
  validates :box_size, inclusion: { in: SIZES.keys, :message => "must be selected" }



  accepts_nested_attributes_for :user
end
