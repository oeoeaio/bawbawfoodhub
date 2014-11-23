class Admin < ActiveRecord::Base
  devise :database_authenticatable
end
