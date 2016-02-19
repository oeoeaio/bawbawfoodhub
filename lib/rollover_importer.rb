require 'roo'

class RolloverImporter
  attr_accessor :season, :file, :created_count, :invalid_emails, :ignored_emails

  def initialize(season, file)
    @season = season
    @file = file
    @invalid_emails = []
    @ignored_emails = []
    @created_count = 0
  end

  def import!
    csv_rows.each do |attrs|
      begin
        ActiveRecord::Base.transaction do
          user = User.find_or_initialize_by(email: attrs[:email])
          attrs.merge!(user.attributes.symbolize_keys.select{ |k,v| k.in?([:given_name, :surname, :phone]) && v.present? })
          unless user.persisted?
            generated_password = Devise.friendly_token.first(10)
            new_user_hash = { password: generated_password, password_confirmation: generated_password, skip_initialisation: "yes"}
            attrs.merge! new_user_hash
          end
          user.update_attributes!(attrs.reject{ |k,v| k == :box_size})

          rollover = Rollover.find_or_initialize_by(season: season, user: user)
          break @ignored_emails << user.email if rollover.persisted?
          rollover.skip_confirmation_notification!
          rollover.update_attributes!(box_size: box_size_from_name(attrs[:box_size]))
          @created_count+=1
        end
      rescue ActiveRecord::RecordInvalid => e
        case e.record
        when User
          @invalid_emails << e.record.email
        when Rollover
          @invalid_emails << e.record.user.email
        end
      end
    end
  end

  private

  def csv_rows
    csv = Roo::CSV.new(file.path)
    rows = csv.parse(given_name: 'Given Name', surname: 'Surname', email: 'Email', phone: 'Phone', box_size: 'Box Size')
    rows[1..-1]
  end

  def box_size_from_name(name)
    case name
    when "Large Box"
      "large"
    when "Standard Box"
      "standard"
    when "Small Bag"
      "small"
    end
  end
end
