class QuestionsController < ApplicationController
  before_filter :validate_rollover_token, only: [:cancel]

  def cancel
    @rollover.cancel
  end
end
