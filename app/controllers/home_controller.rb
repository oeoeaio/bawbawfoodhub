class HomeController < ApplicationController

  def newsletters
    @campaigns = Mailchimp::Api.get_campaigns["campaigns"].sort_by{ |c| c["send_time"] }.reverse
  end
end
