module Mailchimp
  module Api
    include HTTParty

    def self.add_to_list(user)
      mailchimp = Rails.application.secrets.mailchimp
      if mailchimp && mailchimp['api_base_uri'] && mailchimp['api_key'] && mailchimp['list_id']
        response = HTTParty.post("https://#{mailchimp['api_base_uri']}/3.0/lists/#{mailchimp['list_id']}/members", {
          :body => {
            "email_address" => user.email,
            "status" => "subscribed",
            "merge_fields" => {
              "FNAME" => user.given_name,
              "LNAME" => user.surname,
              "PHONE" => user.phone
            }
          }.to_json,
          :headers => {
            'Content-Type' => 'application/json',
            'Accept' => 'application/json',
            'Authorization' => "apikey #{mailchimp['api_key']}"
          }
        })
      end
    end

    def self.get_campaigns
      mailchimp = Rails.application.secrets.mailchimp
      if mailchimp && mailchimp['api_base_uri'] && mailchimp['api_key'] && mailchimp['list_id']
        query_string = "count=20&status=sent&list_id=#{mailchimp["list_id"]}"
        query_string += "&since_send_time=#{2.months.ago.iso8601}"
        response = HTTParty.get("https://#{mailchimp['api_base_uri']}/3.0/campaigns?#{query_string}", {
          :headers => {
            'Accept' => 'application/json',
            'Authorization' => "apikey #{mailchimp['api_key']}"
          }
        })
      end
    end
  end
end
