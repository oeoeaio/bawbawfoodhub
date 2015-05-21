class RolloversController < ApplicationController
  before_filter :validate_rollover_token, only: [:cancel]

  def cancel
    @rollover.update_attribute(:cancelled_at, Time.now)
  end
end
