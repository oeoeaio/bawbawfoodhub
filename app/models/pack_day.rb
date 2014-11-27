class PackDay < ActiveRecord::Base
  belongs_to :season

  validates :season, presence: true
  validates :pack_date, presence: true
end
