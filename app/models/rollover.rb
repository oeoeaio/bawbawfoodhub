class Rollover < ActiveRecord::Base
  include BoxSize
  belongs_to :season
  belongs_to :user
  devise :confirmable, reconfirmable: false

  validates :season, presence: true
  validates :user, presence: true

  # Send confirmation instructions by email
  # This is an override of the devise method
  # Changes:
  # 1. Uses our own mailer and mail action
  # 2. Removes logic around reconfirmation
  def send_confirmation_instructions
    unless @raw_confirmation_token
      generate_confirmation_token!
    end

    RolloverMailer.confirmation_instructions(self, @raw_confirmation_token).deliver_now
  end

  def reset_confirmation_token!(raw)
    enc = Devise.token_generator.digest(Rollover, :confirmation_token, raw)
    self.confirmation_token   = enc
    self.confirmed_at         = nil
    self.confirmation_sent_at = Time.now.utc
    save(validate: false)
  end

  def status
    return "cancelled" if cancelled?
    return "confirmed" if confirmed?
    return "unsent" if (confirmation_sent_at - created_at < 2.seconds)
    "unconfirmed"
  end

  def cancelled?
    !cancelled_at.nil?
  end

  def cancel
    update_attribute(:cancelled_at, Time.now)
  end

  def build_subscription
    Subscription.new( user: user, season: season, box_size: box_size )
  end

  protected

  # This is an override of the devise method
  # Changes:
  # 1. Removed: && self.email.present?
  def send_confirmation_notification?
    confirmation_required? && !@skip_confirmation_notification
  end
end
