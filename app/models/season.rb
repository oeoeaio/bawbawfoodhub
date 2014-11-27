class Season < ActiveRecord::Base
  has_many :subscriptions
  has_many :pack_days
  has_many :users, through: :subscriptions

  validates :slug, uniqueness: true, presence: true

  def to_param
    slug
  end
end
