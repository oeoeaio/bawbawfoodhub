class Subscription < ActiveRecord::Base
  SIZES = {
    "small" => {
      name: 'Small Bag',
      price: '$20',
      desc: 'We offer this smaller package of delicious fresh veggies to cater for the needs of smaller households of one or two people.'
    },
    "standard" => {
      name: 'Standard Box',
      price: '$30',
      desc: 'Our standard weekly box of vegetables is our most popular, and is packed with fresh seasonal produce for 2-3 people for a week.'
    },
    "large" => {
      name: 'Large Box',
      price: '$45',
      desc: 'The large version of our weekly box is suitable for bigger households, and contains enough vegetables to feed around 3-4 people for a week.'
    }
  }

  belongs_to :season
  belongs_to :user
  validates :season, presence: true
  validates :user, presence: true
  validates :box_size, inclusion: { in: SIZES.keys, :message => "must be selected" }

  accepts_nested_attributes_for :user
end
