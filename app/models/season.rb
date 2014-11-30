class Season < ActiveRecord::Base
  has_many :subscriptions
  has_many :pack_days
  has_many :users, through: :subscriptions

  validates :slug, uniqueness: true, presence: true

  def to_param
    slug
  end

  def first_pack
    pack_days.order(pack_date: :asc).first
  end

  def last_pack
    pack_days.order(pack_date: :asc).last
  end

  def next_pack_with_lead_time_from(time)
    packs_after(time + 1.5.days).first
  end

  def packs_after(time)
    pack_days.order(pack_date: :asc)
    .select{ |pd| pd.pack_date.to_time > time }
  end
end
