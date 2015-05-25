class Subscription < ActiveRecord::Base
  include BoxSize
  belongs_to :season
  belongs_to :user
  validate :ensure_season_is_open, on: :create
  validates :season, presence: true
  validates :user, presence: true
  validates :box_size, inclusion: { in: SIZES.keys, :message => "must be selected" }

  accepts_nested_attributes_for :user

  attr_accessor :skip_confirmation_email
  after_create :send_confirmation, unless: :skip_confirmation_email?

  private

  def skip_confirmation_email?
    skip_confirmation_email == "yes"
  end

  def send_confirmation
    # begin
      mail = SubscriptionMailer.confirmation(self).deliver
    # rescue SomethingError
    #   errors.add(:email, "could not be delivered to")
    # end
  end

  def ensure_season_is_open
    if !season.signups_open
      errors.add(:season,"is not open for signups")
    elsif !season.first_pack_day_with_lead_time_after(Time.now)
      errors.add(:season,"has no pack days remaining")
    end
  end
end
