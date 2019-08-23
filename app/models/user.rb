class User < ActiveRecord::Base
  devise :database_authenticatable, :recoverable, :validatable

  has_many :subscriptions
  has_many :seasons, through: :subscriptions

  validates :given_name, presence: true
  validates :surname, presence: true

  attr_accessor :skip_initialisation
  after_save :initialise, if: :saved_change_to_encrypted_password?, unless: :skip_initialisation?

  def skip_initialisation?
    initialised? || skip_initialisation == "yes"
  end

  def initialised?
    !!initialised_at
  end

  def initialise
    update_attribute(:initialised_at, Time.now)
  end
end
