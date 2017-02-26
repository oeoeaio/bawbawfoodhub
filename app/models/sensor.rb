class Sensor < ActiveRecord::Base
  has_many :readings
end
