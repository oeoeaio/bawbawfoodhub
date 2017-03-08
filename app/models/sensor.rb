class Sensor < ActiveRecord::Base
  has_many :readings
  has_many :alerts
end
