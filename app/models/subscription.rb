class Subscription < ActiveRecord::Base
  SIZES = {
    "small" => {
      name: 'Small Bag',
      price: '$20',
      value: 20,
      desc: 'We offer this smaller package of delicious fresh veggies to cater for the needs of smaller households of one or two people.'
    },
    "standard" => {
      name: 'Standard Box',
      price: '$30',
      value: 30,
      desc: 'Our standard weekly box of vegetables is our most popular, and is packed with fresh seasonal produce for 2-3 people for a week.'
    },
    "large" => {
      name: 'Large Box',
      price: '$45',
      value: 45,
      desc: 'The large version of our weekly box is suitable for bigger households, and contains enough vegetables to feed around 3-4 people for a week.'
    }
  }

  belongs_to :season
  belongs_to :user
  validate :ensure_season_is_open
  validates :season, presence: true
  validates :user, presence: true
  validates :box_size, inclusion: { in: SIZES.keys, :message => "must be selected" }

  accepts_nested_attributes_for :user

  after_save :send_confirmation

  private

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
