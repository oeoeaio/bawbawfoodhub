class Subscription < ActiveRecord::Base
  include BoxSize
  belongs_to :user
  validates :user, presence: true
  validates :box_size, inclusion: { in: SIZES.keys, :message => "must be selected" }
  validates :frequency, presence: true, inclusion: { in: ['weekly','fortnightly'], message: 'must be either weekly or fortnightly' }
  validates :delivery, inclusion: { in: [true, false], message: 'cannot be blank' }
  validates :street_address, presence: true, if: :delivery?
  validates :town, presence: true, if: :delivery?
  validates :postcode, presence: true, if: :delivery?

  accepts_nested_attributes_for :user

  attr_accessor :skip_confirmation_email
  after_create :send_confirmation, unless: :skip_confirmation_email?

  def full_address
    [street_address,town,postcode].join(", ")
  end

  private

  def skip_confirmation_email?
    skip_confirmation_email == "yes"
  end

  def send_confirmation
    SubscriptionMailer.confirmation(self).deliver_now
  end
end
