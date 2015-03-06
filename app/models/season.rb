class Season < ActiveRecord::Base
  LEAD_TIME = 36.hours

  has_many :subscriptions
  has_many :pack_days
  has_many :users, through: :subscriptions
  has_many :rollovers

  validates :slug, uniqueness: true, presence: true

  def to_param
    slug
  end

  def first_pack_day
    pack_days.order(pack_date: :asc).first
  end

  def last_pack_day
    pack_days.order(pack_date: :asc).last
  end

  def first_pack_day_with_lead_time_after(time)
    first_pack_day_after(time + LEAD_TIME)
  end

  def first_pack_day_after(time)
    pack_days_after(time).first
  end

  def pack_days_with_lead_time_after(time)
    pack_days_after(time + LEAD_TIME)
  end

  def pack_days_after(time)
    pack_days.order(pack_date: :asc)
    .select{ |pd| Time.zone.parse(pd.pack_date.to_s) > time }
  end
end
