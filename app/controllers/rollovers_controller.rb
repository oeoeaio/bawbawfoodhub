class RolloversController < ApplicationController
  before_filter :validate_rollover_token, only: [:cancel]

  def cancel
    @rollover.cancel
  end
end
