class Rollover < ActiveRecord::Base
  belongs_to :season
  belongs_to :subscription
  delegate :user, to: :subscription
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

  def reset_confirmation_token!(raw)
    enc = Devise.token_generator.digest(Rollover, :confirmation_token, raw)
    self.confirmation_token   = enc
    self.confirmed_at         = nil
    self.confirmation_sent_at = Time.now.utc
    save(validate: false)
  end

  protected

  # This is an override of the devise method
  # Changes:
  # 1. Removed: && self.email.present?
  def send_confirmation_notification?
    confirmation_required? && !@skip_confirmation_notification
  end
end
