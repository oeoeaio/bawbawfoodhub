class Rollover < ActiveRecord::Base
  belongs_to :season
  belongs_to :subscription
  devise :confirmable, reconfirmable: false

  validates :season, presence: true
  validates :subscription, presence: true

  # Send confirmation instructions by email
  # This is an override of the devise method
  # Changes:
  # 1. Uses our own mailer and mail action
  # 2. Removes logic around reconfirmation
  def send_confirmation_instructions
    unless @raw_confirmation_token
      generate_confirmation_token!
    end

    RolloverMailer.confirmation_instructions(self).deliver
  end

  protected

  # This is an override of the devise method
  # Changes:
  # 1. Removed: && self.email.present?
  def send_confirmation_notification?
    confirmation_required? && !@skip_confirmation_notification
  end
end
