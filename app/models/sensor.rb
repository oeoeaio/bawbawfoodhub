class Sensor < ActiveRecord::Base
  has_many :readings
  has_many :alerts

  scope :active, -> { where(active: true) }

  validates :identifier, presence: true, uniqueness: true
  validates :fail_count_for_value_alert, numericality: { only_integer: true, greater_than: 0 }
  validates :upper_limit, :lower_limit, numericality: true

  def last_reading
    readings.order(recorded_at: :desc).limit(1).first
  end

  def last_n_readings(n)
    readings.order(recorded_at: :desc).limit(n).first(n)
  end

  def fail_count_reached?
    value_failures_in_last_n_readings == fail_count_for_value_alert
  end

  private

  def value_failures_in_last_n_readings
    last_n_readings(fail_count_for_value_alert).count do |reading|
      !reading.value.between?(lower_limit, upper_limit)
    end
  end
end
