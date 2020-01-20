class HomeController < ApplicationController
  def index
    # flash[:alert] = "We will be open up to and including Christmas Eve, then closed until Tue 14th of Jan." unless Date.today > Date.new(2020, 1, 13)
  end

  def newsletters
    @campaigns = Mailchimp::Api.get_campaigns["campaigns"].sort_by{ |c| c["send_time"] }.reverse
  end

  def questions
    @faq_groups = FaqGroup.preload(:faqs)
  end
end
