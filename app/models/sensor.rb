class Sensor < ActiveRecord::Base
  has_many :readings
  has_many :alerts

  scope :active, -> { where(active: true) }

  def last_reading
    readings.order(recorded_at: :desc).limit(1).first
  end
end
